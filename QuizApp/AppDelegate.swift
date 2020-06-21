//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Sanja Jerkovic on 5/9/20.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.string(forKey: "token")
        let id = userDefaults.string(forKey: "user_id")
        
        if(token == nil || id == nil){
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = navigationController
            
            window?.makeKeyAndVisible()
            return true
        }
        
        let navigationController = UINavigationController(rootViewController: InitialViewController())
        navigationController.tabBarItem = UITabBarItem(title: "Quizzes", image: nil,  tag: 0)
        
        let settingsController = SettingsViewController()
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: nil,  tag: 0)
        
        let searchController = UINavigationController(rootViewController: SearchViewController())
        searchController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
        
        let tabController = UITabBarController()
        tabController.viewControllers = [navigationController, settingsController, searchController]
        
        window?.rootViewController = tabController
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

