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
    
    @IBAction func doAction(_ sender: AnyObject) {
        let actions = [
            WKAlertAction(title: "Text Message", style: .default, handler: {[unowned self] () -> Void in
                self.textRequest()
            }),
            WKAlertAction(title: "Cancel", style: .cancel, handler: { () -> Void in
                // pass
            })
        ]
        
        self.presentAlert(
            withTitle: "Choose action", message:
            .none,
            preferredStyle: .actionSheet,
            actions: actions
        )
    }
    
    fileprivate func textRequest() {
        let sugessions = [
            "Hello",
            "How are your?"
        ]
        
        self.presentTextInputController(
            withSuggestions: sugessions,
            allowedInputMode: .plain) { (results) -> Void in
                guard let results = results as? [String] else {
                    return
                }
                
                guard let text = results.first else {
                    return
                }
                
                self.showProgress()
                
                let api = ApiAI.shared()
                
                let request = api?.textRequest()
                request?.query = text
                
                request?.setMappedCompletionBlockSuccess(
                    { (request, response) -> Void in
                        let response = response as! AIResponse
                        
                        var speech = response.result.fulfillment.speech
                        
                        if (speech?.characters.count == 0) {
                            speech = "<empty speech>"
                        }
                        
                        self.button.setTitle(speech)
                        
                        self.dismissProgress()
                    }, failure: { (request, error) -> Void in
                        self.dismissProgress()
                    }
                )
                
                api?.enqueue(request)
        }
    }
    
    fileprivate func showProgress() {
        button.setHidden(true)
        progressImage.setHidden(false)
        progressImage.startAnimating()
    }
    
    fileprivate func dismissProgress() {
        button.setHidden(false)
        progressImage.setHidden(true)
        progressImage.stopAnimating()
    }
}
