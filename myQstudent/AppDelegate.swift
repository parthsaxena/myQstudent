//
//  AppDelegate.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/10/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import UIKit
import Pastel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let pastelView = PastelView(frame: UIScreen.main.bounds)
        pastelView.startPastelPoint = .topLeft
        pastelView.endPastelPoint = .bottomRight
        pastelView.animationDuration = 2.5
        pastelView.setColors([UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0),
                              UIColor(red: 73/255, green: 112/255, blue: 204/255, alpha: 1.0),
                              UIColor(red: 79/255, green: 167/255, blue: 89/255, alpha: 1.0),
                              UIColor(red: 198/255, green: 203/255, blue: 146/255, alpha: 1.0),
                              UIColor(red: 245/255, green: 48/255, blue: 88/255, alpha: 1.0)])
        pastelView.startAnimation()
        UIApplication.shared.delegate?.window??.addSubview(pastelView)
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

