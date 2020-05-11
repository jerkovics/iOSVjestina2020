//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/9/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = InitialViewController()
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

