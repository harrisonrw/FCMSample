//
//  AppDelegate.swift
//  FCMSample
//
//  Created by Robert Harrison on 6/30/20.
//  Copyright © 2020 RWH Technology, LLC. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start Firebase
        FirebaseApp.configure()
        
        // Start Firebase Messaging
        Messaging.messaging().delegate = self
        
        // Register for Remote Notifications
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in }
        )
        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Remote Notification Handling
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(.newData)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // Handle incoming notification messages while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler([.badge, .alert])
    }
    
    // Handle notification messages after display notification is tapped by the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        // Convert userInfo to data, so we can use the JSONDecoder on it.
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted) else {
            completionHandler()
            return
        }
        
        // Get the payload from the data.
        guard let payload = try? JSONDecoder().decode(FCMPayload.self, from: data) else {
            completionHandler()
            return
        }
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController as? ViewController else {
            completionHandler()
            return
        }
        
        // Present the message.
        let messageViewController = MessageViewController.configured(message: payload.aps.message)
        viewController.present(messageViewController, animated: true, completion: nil)
        
        completionHandler()
    }
    
    // MARK: - MessagingDelegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // This is called on each app startup and whenever a new token is generated.
        
        print("FCM Registration Token: \(fcmToken)")
        
        // TODO: If necessary, send token to application server.
    }


}

