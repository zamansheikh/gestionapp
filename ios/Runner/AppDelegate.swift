import Flutter
import UIKit
import FirebaseCore
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    //add Here,
      // This is required to make any communication available in the action isolate.
       FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
         GeneratedPluginRegistrant.register(with: registry)
       }
      
      
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      
    //Add here,
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
