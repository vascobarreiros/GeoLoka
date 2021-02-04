//
//  GeoLokaApp.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import SwiftUI
import UserNotifications


@main
struct GeoLokaApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let signWithAppleManger = SignInWithAppleManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(signWithAppleManger)
               
                
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
   static var geolokaToken = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // print("Your code here")
        registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
            UNUserNotificationCenter.current()
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                // 1. Check if permission granted
                guard granted else { return }
                // 2. Attempt registration for remote notifications on the main thread
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
         // 1. Convert device token to string
         let tokenParts = deviceToken.map { data -> String in
             return String(format: "%02.2hhx", data)
         }
         let token = tokenParts.joined()
         // 2. Print device token to use for PNs payloads
         print("Device Token: \(token)")
         AppDelegate.geolokaToken = token
         
        // This needs to be uploaded to the server - because then it will be need it to send the push messages - each device has its unique token
     }

     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         // 1. Print out error if PNs registration not successful
         print("Failed to register for remote notifications with error: \(error)")
     }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
}
