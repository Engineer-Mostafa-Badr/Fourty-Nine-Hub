import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import flutter_local_notifications
import GoogleMaps
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyCSzHt1y3RDKvC2D67mF-WJdyZKE9hBIxA")
      FirebaseApp.configure()

      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback {(registry) in
       GeneratedPluginRegistrant.register(with: registry)}

       
       GeneratedPluginRegistrant.register(with: self)

      // Request notification permissions and register for remote notifications
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }

      application.registerForRemoteNotifications()
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle APNS token registration
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Set the APNS token for Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // Handle APNS token registration failure
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error)")
  }
}
