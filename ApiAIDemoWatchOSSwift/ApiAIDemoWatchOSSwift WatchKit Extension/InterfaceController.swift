//
//  InterfaceController.swift
//  ApiAIDemoWatchOSSwift WatchKit Extension
//
//  Created by Kuragin Dmitriy on 21/10/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

import WatchKit
import Foundation
import ApiAI


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var button: WKInterfaceButton!
    @IBOutlet weak var progressImage: WKInterfaceImage!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    @IBAction func doAction(sender: AnyObject) {
        let actions = [
            WKAlertAction(title: "Text Message", style: .Default, handler: {[unowned self] () -> Void in
                self.textRequest()
            }),
            WKAlertAction(title: "Voice Message", style: .Default, handler: {[unowned self] () -> Void in
                self.voiceRequest()
            }),
            WKAlertAction(title: "Cancel", style: .Cancel, handler: { () -> Void in
                // pass
            })
        ]
        
        self.presentAlertControllerWithTitle(
            "Choose action", message:
            .None,
            preferredStyle: .ActionSheet,
            actions: actions
        )
    }
    
    private func textRequest() {
        let sugessions = [
            "Hello",
            "How are your?"
        ]
        
        self.presentTextInputControllerWithSuggestions(
            sugessions,
            allowedInputMode: .Plain) { (results) -> Void in
                guard let results = results as? [String] else {
                    return
                }
                
                guard let text = results.first else {
                    return
                }
                
                let api = ApiAI.sharedApiAI()
                
                let request = api.textRequest()
                request.query = text
                
                request.setMappedCompletionBlockSuccess(
                    { (request, response) -> Void in
                        
                    }, failure: { (request, error) -> Void in
                        
                    }
                )
        }
    }
    
    private func voiceRequest() {
    
    }
    
    private func showProgress() {
        button.setHidden(true)
        progressImage.setHidden(false)
        progressImage.startAnimating()
    }
    
    private func dismissProgress() {
        button.setHidden(false)
        progressImage.setHidden(true)
        progressImage.stopAnimating()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
