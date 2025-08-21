import HealthKit
import Foundation
import Flutter


final class WorkoutsImpl: NSObject, HealthKitWorkoutApi {
  let healthStore = HKHealthStore()

  func getWorkouts() throws -> [HKWorkoutData?] {
    return try buildWorkouts().map { Optional($0) }
  }


  private func buildWorkouts() throws -> [HKWorkoutData] {

    var workoutsData: [HKWorkoutData] = []
    let semaphore = DispatchSemaphore(value: 0)
    var queryError: Error?

    let predicate = HKQuery.predicateForSamples(
      withStart: Date.distantPast,
      end: Date(),
      options: []
    )
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
    let query = HKSampleQuery(
      sampleType: .workoutType(), predicate: predicate, limit: 3, sortDescriptors: [sortDescriptor]
    ) { _, samples, error in

      if let err = error {
        queryError = err
        semaphore.signal()
        return
      }

      guard let workouts = samples as? [HKWorkout] else {
        semaphore.signal()
        return
      }
      let group = DispatchGroup()

      for w in workouts {
        var data = HKWorkoutData()
        let iso = ISO8601DateFormatter()
        data.start = iso.string(from: w.startDate)
        data.end = iso.string(from: w.endDate)
        data.sport = w.workoutActivityType.name
        if #available(iOS 11.0, *) {
          data.source = w.sourceRevision.source.name
        } else {
          data.source = nil
        }
        let distanceMeters = w.totalDistance?.doubleValue(for: .meter()) ?? 0
        data.distance = distanceMeters
        let durationSec = w.duration
        data.avgSpeed = durationSec > 0 ? (distanceMeters / durationSec) * 3.6 : 0
        let calories = w.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
        data.caloriesKcal = calories

        // We'll fill avgBPM, maxBPM, bpmDataPoints, speedDataPoints below

        // Per-workout dispatch group
        group.enter()
        let wg = DispatchGroup()

        var bpmPoints: [BPMDataPoint] = []
        var speedPoints: [SpeedDataPoint] = []

        // HR stats (avg / max)
        wg.enter()
        self.fetchHeartRateStats(for: w) { avg, max in
          data.avgBPM = avg
          data.maxBPM = max
          wg.leave()
        }

        // HR series (all points)
        wg.enter()
        self.fetchHeartRateSamples(for: w) { points in
          bpmPoints = points.map { (ts, bpm) in
            BPMDataPoint(timestamp: iso.string(from: ts), bpm: bpm)
          }
          wg.leave()
        }

        // Running speed / pace series (with fallback via distance samples)
        wg.enter()
        self.fetchRunningSpeedSamples(for: w) { points in
          if points.count > 0 {
            speedPoints = points.map { (ts, mps) in
              let kmh = mps * 3.6
              let paceMinPerKm = mps > 0 ? (1000.0 / mps) / 60.0 : Double.infinity
              return SpeedDataPoint(timestamp: iso.string(from: ts), kmh: kmh, paceMinPerKm: paceMinPerKm)
            }
            wg.leave()
          } else {
            self.fetchDistanceSegments(for: w) { segments in
              speedPoints = segments.compactMap { (start, end, meters) in
                let dt = end.timeIntervalSince(start)
                guard dt > 0, meters >= 0 else { return nil }
                let mps = meters / dt
                let kmh = mps * 3.6
                let paceMinPerKm = mps > 0 ? (1000.0 / mps) / 60.0 : Double.infinity
                let mid = start.addingTimeInterval(dt / 2.0)
                return SpeedDataPoint(timestamp: iso.string(from: mid), kmh: kmh, paceMinPerKm: paceMinPerKm)
              }
              wg.leave()
            }
          }
        }

        // When the 3 async parts are done, finalize and append
        wg.notify(queue: .global()) {
          data.bpmDataPoints = bpmPoints
          data.speedDataPoints = speedPoints
          workoutsData.append(data)
          group.leave()
        }
      }

      // Flag pour savoir si group.notify a déjà signalé
      var signaled = false

      // Timeout de sécurité
      DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
        if !signaled {
          print("⚠️ Timeout atteint, libération du sémaphore pour éviter un blocage")
          semaphore.signal()
        }
      }

      // Signal normal quand toutes les HR sont traitées
      group.notify(queue: DispatchQueue.global()) {
        signaled = true
        print("✅ Fin des queries HR, signal du sémaphore")
        semaphore.signal()
      }
    }

    healthStore.execute(query)
    semaphore.wait()

    if let err = queryError {
      throw err
    }

    return workoutsData
  }


  func fetchHeartRateStats(for workout: HKWorkout, completion: @escaping (Double?, Double?) -> Void)
  {

    guard
      let avgHeartRate = HKSampleType.quantityType(
        forIdentifier: HKQuantityTypeIdentifier.heartRate)
    else {
      // This should never fail when using a defined constant.
      fatalError("*** Unable to get the dietary energy consumed type ***")
    }

    let calendar = NSCalendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month, .day], from: now)

    guard let startDate = calendar.date(from: components) else {
      fatalError("*** Unable to create the start date ***")
    }

    guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
      fatalError("*** Unable to create the end date ***")
    }

    let workoutTimestamp = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: [])

    let query = HKStatisticsQuery(
      quantityType: avgHeartRate, quantitySamplePredicate: workoutTimestamp, options: [.discreteAverage, .discreteMax]
    ) { (query, statisticsOrNil, errorOrNil) in

      guard let statistics = statisticsOrNil else {
        return
      }

      let avg = statistics.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
      let max = statistics.maximumQuantity()?.doubleValue(for: HKUnit(from: "count/min"))

      print("La moyenne heart : \(avg)")

      completion(avg, max)

    }

    healthStore.execute(query)
  }

  // Fetch every heart-rate sample within the workout window, sorted by time (ascending)
  func fetchHeartRateSamples(for workout: HKWorkout, completion: @escaping ([(Date, Double)]) -> Void) {
    guard let hrType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
      completion([])
      return
    }

    // Constrain samples to the workout timeframe
    let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: [])
    let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

    let q = HKSampleQuery(sampleType: hrType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { [weak self] (_, samples, error) in
      guard error == nil, let samples = samples as? [HKQuantitySample] else {
        completion([])
        return
      }

      let unit = HKUnit(from: "count/min")
      let points: [(Date, Double)] = samples.map { s in
        (s.startDate, s.quantity.doubleValue(for: unit))
      }
      completion(points)
    }

    healthStore.execute(q)
  }

  // Fallback: build speed/pace from DistanceWalkingRunning samples (segment distance / segment duration)
  func fetchDistanceSegments(for workout: HKWorkout, completion: @escaping ([(Date, Date, Double)]) -> Void) {
    guard let distType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
      completion([])
      return
    }

    let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: [])
    let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

    let q = HKSampleQuery(sampleType: distType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { (_, samples, error) in
      guard error == nil, let samples = samples as? [HKQuantitySample] else {
        completion([])
        return
      }

      let unit = HKUnit.meter()
      let segments: [(Date, Date, Double)] = samples.map { s in
        (s.startDate, s.endDate, s.quantity.doubleValue(for: unit))
      }
      completion(segments)
    }

    healthStore.execute(q)
  }

  // Fetch every running-speed sample within the workout window (iOS 16+), return tuples of (date, m/s)
  func fetchRunningSpeedSamples(for workout: HKWorkout, completion: @escaping ([(Date, Double)]) -> Void) {
    guard #available(iOS 16.0, *) else {
      completion([])
      return
    }
    guard let speedType = HKObjectType.quantityType(forIdentifier: .runningSpeed) else {
      completion([])
      return
    }

    let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: [])
    let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)

    let q = HKSampleQuery(sampleType: speedType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { (_, samples, error) in
      guard error == nil, let samples = samples as? [HKQuantitySample] else {
        completion([])
        return
      }

      let unit = HKUnit(from: "m/s")
      let points: [(Date, Double)] = samples.map { s in
        (s.startDate, s.quantity.doubleValue(for: unit))
      }
      completion(points)
    }

    healthStore.execute(q)
  }

}

extension HKWorkoutActivityType {
  var name: String {
    switch self {
    case .running: return "running"
    case .cycling: return "cycling"
    case .hiking: return "hiking"
    case .walking: return "walking"
    case .swimming: return "swimming"
    case .traditionalStrengthTraining: return "fitness"
    case .other: return "other"
    default: return "unknown"
    }
  }
}
