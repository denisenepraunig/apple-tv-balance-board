//
//  AppDelegate.swift
//  BalanceBoardStarter1
//
//  Created by Denise Nepraunig on 20.02.18.
//  Copyright © 2018 Denise Nepraunig. All rights reserved.
//

import UIKit
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var gamePad: GCController? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // the game controller coding is inspired by:
        // https://www.bignerdranch.com/blog/tvos-games-part-1-using-the-game-controller-framework/
        startWatchingForControllers()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

// MARK: Game Controller coding
extension AppDelegate {
    
    func startWatchingForControllers() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { note in
            
            if let gameController = note.object as? GCController {
                
                self.gamePad = gameController
                self.addController(gameController)
            }
        }
        notificationCenter.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { note in
            
            if let gameController = note.object as? GCController {
                
                self.gamePad = nil
                self.removeController(gameController)
            }
        }
        
        GCController.startWirelessControllerDiscovery(completionHandler: {})
    }
    
    func stopWatchingForControllers() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        notificationCenter.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        
        GCController.stopWirelessControllerDiscovery()
    }
    
    
    func addController(_ controller: GCController) {
        
        let name = String(describing:controller.vendorName)
        
        // in the simulator the Siri Remote will show up as an extended game pad
        // please test this on a real Apple TV
        if let extendedGamepad = controller.extendedGamepad {
            print("connect extended gampad \(name)")
            
        } else if let microGamepad = controller.microGamepad {
            
            print("connect micro gamepad \(name)")
            registerMicroGamePadEvents(microGamepad)
        } else {
            print("unknown? \(name)")
        }
    }
    
    func removeController(_ controller: GCController) {
        
        print("disconnect")
    }
    
    func registerMicroGamePadEvents(_ microGamePad: GCMicroGamepad) {
        
        let motionHandler: GCMotionValueChangedHandler = { (motion: GCMotion) -> () in
            
            //print("acc:\(motion.userAcceleration)")
            //print("grav:\(motion.gravity)")
            //print("att:\(motion.attitude)")
            //print("rot:\(motion.rotationRate)")
        }
        
        gamePad?.motion?.valueChangedHandler = motionHandler
    }
}

