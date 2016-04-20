    //
//  AppDelegate.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit
import HockeySDK
import AeroGearPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Get the devices screenbounds for UI placement
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        self.window = UIWindow(frame: screenBounds);
        
//        IQKeyboardManager.sharedManager().enable = true
        
        // main VC
        let viewController:UIViewController = LoginAppViewController()

        // set the root view controller in the naviagation controller
        let nav:UINavigationController = UINavigationController(rootViewController: viewController);
        
        self.window?.rootViewController = nav;
        self.window?.makeKeyAndVisible();
        
        // set the color of the title text in the navbar
        UINavigationBar.appearance().tintColor = Constants.AppColors.blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : Constants.AppColors.blueColor]
        
        //HockeyApp
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("65b81ff6402f4385b9b6e020d24a0fea")
        // Do some additional configuration if needed here
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()

        
        // Push Notifications
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert,UIUserNotificationType.Badge,UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        
        return true
    }
    
    // MARK: - PUSH NOTIFICATIONS
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("APNS Success")
        
        let registration = AGDeviceRegistration(serverURL: NSURL(string: "https://aerogear2-hideoutapps.rhcloud.com/ag-push/")!)

        
        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!)  in
            
            // apply the token, to identify this device
            clientInfo.deviceToken = deviceToken
            print(deviceToken)
            
            clientInfo.variantID = "77a37c2e-b9ae-4314-aadd-dd24663af2e1"
            clientInfo.variantSecret = "e2d86ebd-c888-42f4-8248-e0f46a579a0e"
            
            // --optional config--
            // set some 'useful' hardware information params
            let currentDevice = UIDevice()
            clientInfo.operatingSystem = currentDevice.systemName
            clientInfo.osVersion = currentDevice.systemVersion
            clientInfo.deviceType = currentDevice.model
            
            }, success: {
                print("UPS registration worked");
                
            }, failure: { (error:NSError!) -> () in
                print("UPS registration Error: \(error.localizedDescription)")
        })
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

