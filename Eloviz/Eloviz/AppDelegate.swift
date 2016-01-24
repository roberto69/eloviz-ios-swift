//
//  AppDelegate.swift
//  Eloviz
//
//  Created by guillaume labbe on 05/12/15.
//  Copyright © 2015 guillaume labbe. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor(red: 24/255, green: 29/255, blue: 40/255, alpha: 1)
        window?.makeKeyAndVisible()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootController = storyboard.instantiateViewControllerWithIdentifier("HomePage")
        self.navigationController = UINavigationController(rootViewController: rootController)
        self.window?.rootViewController = self.navigationController
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        navigationController?.navigationBar.translucent = false
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationController?.navigationBarHidden = true
        
        setUpLocalDataStore()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        /*if (!NSUserDefaults.standardUserDefaults().boolForKey("alreadyLaunch")) {
            let tutorialVC = TutorialPageView()
            self.window?.rootViewController?.presentViewController(tutorialVC, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "alreadyLaunch")
        }*/
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstLaunch")
        MagicalRecord.cleanUp()
    }
    
    
    func setUpLocalDataStore() {
        MagicalRecord.setupAutoMigratingCoreDataStack()
    }
}

