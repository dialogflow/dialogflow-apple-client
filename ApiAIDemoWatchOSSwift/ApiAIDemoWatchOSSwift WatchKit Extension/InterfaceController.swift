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
                
                self.showProgress()
                
                let api = ApiAI.sharedApiAI()
                
                let request = api.textRequest()
                request.query = text
                
                request.setMappedCompletionBlockSuccess(
                    { (request, response) -> Void in
                        let response = response as! AIResponse
                        
                        var speech = response.result.fulfillment.speech
                        
                        if (speech.characters.count == 0) {
                            speech = "<empty speech>"
                        }
                        
                        self.button.setTitle(speech)
                        
                        self.dismissProgress()
                    }, failure: { (request, error) -> Void in
                        self.dismissProgress()
                    }
                )
                
                api.enqueue(request)
        }
    }
    
    private func voiceRequest() {
        let filePaths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask,
            true)
        
        let documentDir = filePaths.first!
        let recSoundURL = documentDir + "/record.m4a"
        let URL = NSURL.fileURLWithPath(recSoundURL)
        
        let options = [
            WKAudioRecorderControllerOptionsMaximumDurationKey: 10.0
        ]
        
        self.presentAudioRecorderControllerWithOutputURL(
            URL,
            preset: .WideBandSpeech,
            options: options) { (didSave, error) -> Void in
                if error == .None {
                    self.showProgress()
                    
                    let api = ApiAI.sharedApiAI()
                    
                    let request = api.voiceFileRequestWithFileURL(URL)
                
                    request.setMappedCompletionBlockSuccess(
                        { (request, response) -> Void in
                            let response = response as! AIResponse
                            
                            var speech = response.result.fulfillment.speech
                            
                            if (speech.characters.count == 0) {
                                speech = "<empty speech>"
                            }
                            
                            self.button.setTitle(speech)
                            
                            self.dismissProgress()
                        
                        }, failure: { (request, error) -> Void in
                            self.dismissProgress()
                    })
                    
                    api.enqueue(request)
                }
        }
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
