/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 

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
