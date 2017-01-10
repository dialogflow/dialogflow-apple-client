//
//  SimpleVoiceRequestController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 26/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit

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
    
    @IBAction func startListening(_ sender: UIButton) {
        self.changeStateToListening()

        let apiai = ApiAI.shared()
        
        let request = apiai?.voiceRequest()
        
        if let vad = self.useVAD {
            request?.useVADForAutoCommit = vad.isOn
        }
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            let resultNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultNavigationController
            
            resultNavigationController.response = response as AnyObject?
            
            self.present(resultNavigationController, animated: true, completion: nil)
            
            self.changeStateToStop()
            
        }, failure: { (request, error) -> Void in
            self.changeStateToStop()
        })
        
        self.currentVoiceRequest = request
        
        apiai?.enqueue(request)
    }
    
    @IBAction func stopListening(_ sender: UIButton) {
        self.currentVoiceRequest?.commitVoice()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.currentVoiceRequest?.cancel()
    }
    
    func changeStateToStop() {
        self.activity?.stopAnimating()
        self.startListeningButton?.isEnabled = true
        self.stopListeningButton?.isEnabled = false
        
        self.useVAD?.isEnabled = true
    }
    
    func changeStateToListening() {
        self.activity?.startAnimating()
        self.startListeningButton?.isEnabled = false
        self.stopListeningButton?.isEnabled = true
        
        self.useVAD?.isEnabled = false
    }

}
