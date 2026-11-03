import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override var window: UIWindow? {
    get {
      let w = super.window ?? UIWindow(frame: UIScreen.main.bounds)
      if w.rootViewController == nil {
        w.rootViewController = FlutterViewController()
      }
      super.window = w
      return w
    }
    set {
      super.window = newValue
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configure Firebase
    FirebaseApp.configure()

    // Configure push notifications
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    return super.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
  }

  // Receive APNs device token for Firebase Messaging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken

    super.application(
      application,
      didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
    )
  }
}
