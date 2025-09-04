import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        

        //setup pigeon for HealthKit authorization
        HealthKitAuthorizationSetup.setUp(binaryMessenger: controller.binaryMessenger, api: HealthKitAuthorizationImpl())
        HealthKitWorkoutApiSetup.setUp(binaryMessenger: controller.binaryMessenger,
                                 api: WorkoutsImpl())
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}