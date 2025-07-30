

import HealthKit
import Foundation


class WorkoutsImpl: NSObject, Workouts {
  let healthStore = HKHealthStore()

  func getWorkouts() throws -> [WorkoutData] {

    var workoutsData: [WorkoutData] = []
    let semaphore = DispatchSemaphore(value: 0)
    var queryError: Error?

    let predicate = HKQuery.predicateForSamples(
      withStart: Date.distantPast,
      end: Date(),
      options: []
    )
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
    let query = HKSampleQuery(
      sampleType: .workoutType(), predicate: predicate, limit: 4, sortDescriptors: [sortDescriptor]
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
        var data = WorkoutData()
        data.type = w.workoutActivityType.name
        data.totalDistance = w.totalDistance?.doubleValue(for: .meter())
        data.totalEnergyBurned = w.totalEnergyBurned?.doubleValue(for: .kilocalorie())
        data.duration = w.duration
        data.startDate = ISO8601DateFormatter().string(from: w.startDate)
        data.endDate = ISO8601DateFormatter().string(from: w.endDate)

        // Calcul allure
        if let distance = data.totalDistance, distance > 0 {
          let pace = (w.duration / 60) / (distance / 1000) // minutes par km
          data.avgPace = Double(round(pace * 100) / 100)   // arrondi à 2 décimales
        }

        // HR Query
        group.enter()
        self.fetchHeartRateStats(for: w) { avg, max in
          var completedData = data
          completedData.avgHeartRate = avg
          completedData.maxHeartRate = max
          workoutsData.append(completedData)  // ✅ Ajout après avoir rempli
          print("✅ Ajout workout avec HR: \(String(describing: avg))")
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

    /*
    print("🔍 Query HR for workout from \(workout.startDate) to \(workout.endDate)")
    guard let quantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
      completion(nil, nil)
      return
    }
    
    let predicate = HKQuery.predicateForSamples(
      withStart: workout.startDate.addingTimeInterval(-120), end: workout.endDate.addingTimeInterval(120), options: .strictStartDate)
    
    let query = HKStatisticsQuery(
      quantityType: quantityType, quantitySamplePredicate: predicate,
      options: [.discreteAverage, .discreteMax]
    ) { _, statistics, _ in
      let avg = statistics?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
      let max = statistics?.maximumQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
      completion(avg, max)
    }
    
    let myquery = HKStatisticsQuery(quantityType: energyc, quantitySamplePredicate: NSPredicate?, completionHandler: (HKStatisticsQuery, HKStatistics?, (any Error)?) -> Void)
    
    healthStore.execute(query)
    */
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
