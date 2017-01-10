//
//  AppDelegate.swift
//  APIAiMacOSSwiftDemo
//
//  Created by Grant Kemp on 03/01/2017.
//  Copyright © 2017 Grant Kemp. All rights reserved.
//

import Cocoa
import ApiAI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

 let clientkey_APIAi = "b316a120a0ab4383980746032c21c4f5"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let configuration:AIConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = self.clientkey_APIAi
        ApiAI.shared().configuration = configuration
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

