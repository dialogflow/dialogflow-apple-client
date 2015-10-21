//
//  ExtensionDelegate.swift
//  ApiAIDemoWatchOSSwift WatchKit Extension
//
//  Created by Kuragin Dmitriy on 21/10/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

import WatchKit
import ApiAI

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        let configuration = AIDefaultConfiguration()
        
        configuration.clientAccessToken = ""
        configuration.subscriptionKey = ""
        
        ApiAI.sharedApiAI().configuration = configuration
        
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}
