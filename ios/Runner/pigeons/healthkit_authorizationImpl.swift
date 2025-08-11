import Foundation
import HealthKit

class HealthKitAuthorizationImpl: NSObject, HealthKitAuthorization {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        // ✅ Appel natif HealthKit sans bloquer le main thread
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let err = error {
                completion(.failure(err)) // 🔹 Utilisation de Result.failure
            } else {
                completion(.success(success)) // 🔹 Utilisation de Result.success
            }
        }
    }
}
