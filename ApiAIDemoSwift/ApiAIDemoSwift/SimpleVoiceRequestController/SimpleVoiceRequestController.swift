//
//  SimpleVoiceRequestController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 26/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit
import ApiAI

class SimpleVoiceRequestController: UIViewController {
    
    @IBOutlet var activity: UIActivityIndicatorView? = nil
    @IBOutlet var startListeningButton: UIButton? = nil
    @IBOutlet var stopListeningButton: UIButton? = nil
    @IBOutlet var useVAD: UISwitch? = nil
    
    var currentVoiceRequest: AIVoiceRequest? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeStateToStop()
    }
    
    @IBAction func startListening(sender: UIButton) {
        self.changeStateToListening()

        let apiai = ApiAI.sharedApiAI()
        
        let request = apiai.requestWithType(AIRequestType.Voice) as! AIVoiceRequest
        
        if let vad = self.useVAD {
            request.useVADForAutoCommit = vad.on
        }
        
        request.setCompletionBlockSuccess({[unowned self] (AIRequest request, AnyObject response) -> Void in
            let resultNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultNavigationController
            
            resultNavigationController.response = response
            
            self.presentViewController(resultNavigationController, animated: true, completion: nil)
            
            self.changeStateToStop()
            
        }, failure: { (AIRequest request, NSError error) -> Void in
            println()
            self.changeStateToStop()
        })
        
        self.currentVoiceRequest = request
        
        apiai.enqueue(request)
    }
    
    @IBAction func stopListening(sender: UIButton) {
        self.currentVoiceRequest?.commitVoice()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.currentVoiceRequest?.cancel()
    }
    
    func changeStateToStop() {
        self.activity?.stopAnimating()
        self.startListeningButton?.enabled = true
        self.stopListeningButton?.enabled = false
        
        self.useVAD?.enabled = true
    }
    
    func changeStateToListening() {
        self.activity?.startAnimating()
        self.startListeningButton?.enabled = false
        self.stopListeningButton?.enabled = true
        
        self.useVAD?.enabled = false
    }

}
