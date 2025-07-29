import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // setup pigeon for workouts
        WorkoutsSetup.setUp(binaryMessenger: controller.binaryMessenger, api: WorkoutsImpl())
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}