//
//  ViewController.swift
//  APIAiMacOSSwiftDemo
//
//  Created by Grant Kemp on 03/01/2017.
//  Copyright © 2017 Grant Kemp. All rights reserved.
//

import Cocoa
import ApiAI

class ViewController: NSViewController {

    @IBOutlet weak var obtn_StartListening: NSButton!
    @IBOutlet weak var tf_outputTextBox: NSTextField!
    
    //Api AI
    var request: AIVoiceRequest!
    
    // This is the method that takes the response from Api ai and shows it up in the text field and as an alert.

    @IBAction func abtn_StartListening(_ sender: NSButton) {
        self.obtn_StartListening.isEnabled = false
        self.request = ApiAI.shared().voiceRequest()
        
        
        
        request.setCompletionBlockSuccess({ (success, id) in
            self.obtn_StartListening.isEnabled = true
            let infoText = NSString.localizedStringWithFormat("%@", id as! CVarArg)
            
            self.showResponse(infoText: infoText)
        }) { (request, error) in
            self.obtn_StartListening.isEnabled = true
            }
            ApiAI.shared().enqueue(request)

            }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showResponse(infoText:NSString) {
        let alert = NSAlert()
        alert.informativeText = infoText as String
        tf_outputTextBox.stringValue = infoText as String
        alert.alertStyle = .informational
        alert.runModal()
        
    }
}

