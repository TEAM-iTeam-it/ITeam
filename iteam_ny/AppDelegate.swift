//
//  AppDelegate.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit
import Firebase
<<<<<<< HEAD
=======
import FirebaseCore
>>>>>>> 95a2f6f3aa324734867ab5f38de3e3bcaca945c5

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
<<<<<<< HEAD
        // Override point for customization after application launch.
=======
        
>>>>>>> 95a2f6f3aa324734867ab5f38de3e3bcaca945c5
        FirebaseApp.configure()
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


}

