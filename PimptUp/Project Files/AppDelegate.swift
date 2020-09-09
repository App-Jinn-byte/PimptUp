//
//  AppDelegate.swift
//  PimptUp
//
//  Created by JanAhmad on 18/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift
let googleApiKey = "AIzaSyDH3Q3v492ugZ-TtSDcoOhD4HLvDyGKH2M"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // self.window?.rootViewController = LoginAsViewController()
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleApiKey)
        
        // Override point for customization after application launch.
       
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 5)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 16)!], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        if (UserDefaults.standard.bool(forKey: "LoggedIn") && UserDefaults.standard.integer(forKey: "UserTypeId") == 3){
                   //            let value = UserDefaults.standard.integer(forKey: "UserTypeId")
                   //            print(value)
                   Constants.userId =   UserDefaults.standard.integer(forKey: "UserId")
                   Constants.userTypeId = UserDefaults.standard.integer(forKey: "UserTypeId")
                   Constants.userName = UserDefaults.standard.string(forKey: "UserName") ?? "anonymous"
                   print(Constants.userId)
                   print(UserDefaults.standard.bool(forKey: "LoggedIn"))
                   let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                   //            let nextViewController =  storyboard.instantiateViewController(withIdentifier: "MainTabBar")       as! MainTabBarController
                   //            var viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBarController
                   let nextViewController =  storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBarViewController
            
                   self.window?.rootViewController = nextViewController
               }
                   
               else if (UserDefaults.standard.bool(forKey: "LoggedIn") && UserDefaults.standard.integer(forKey: "UserTypeId") == 2 ){
                   Constants.userId =   UserDefaults.standard.integer(forKey: "UserId")
                   Constants.userTypeId = UserDefaults.standard.integer(forKey: "UserTypeId")
                   Constants.partTypeId = UserDefaults.standard.integer(forKey: "PartTypeId")
                   let storyboard = UIStoryboard(name: "Dealer", bundle: nil)
                   let nextViewController =  storyboard.instantiateViewController(withIdentifier: "MainTabBar2")       as! DealerTabBarViewController
                   //var viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "Contractor") as! ContracterTabBarViewController
                   self.window?.rootViewController = nextViewController
                   //          var vc = storyboard.instantiateInitialViewController() as? ContracterTabBarViewController
               }
        else if (UserDefaults.standard.bool(forKey: "LoggedIn")){
                         Constants.userId =   UserDefaults.standard.integer(forKey: "UserId")
                         Constants.userTypeId = UserDefaults.standard.integer(forKey: "UserTypeId")
                         let storyboard = UIStoryboard(name: "Specialist", bundle: nil)
                         let nextViewController =  storyboard.instantiateViewController(withIdentifier: "MainTabBar3")   as! SpecialistTabBarViewController
                         //var viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "Contractor") as! ContracterTabBarViewController
                         self.window?.rootViewController = nextViewController
                         //          var vc = storyboard.instantiateInitialViewController() as? ContracterTabBarViewController
                     }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

