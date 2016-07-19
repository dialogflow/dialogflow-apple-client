//
//  TextRequestViewController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit

class TextRequestViewController: UIViewController {
    @IBOutlet var textField: UITextField? = nil
    
    @IBAction func sendText(sender: UIButton)
    {
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window!, animated: true)
        
        self.textField?.resignFirstResponder()
        
        let request = ApiAI.sharedApiAI().textRequest()
        
        if let text = self.textField?.text {
            request.query = [text]
        } else {
            request.query = [""]
        }
        
        request.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            let resultNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultNavigationController
            
            resultNavigationController.response = response
            
            self.presentViewController(resultNavigationController, animated: true, completion: nil)
            
            hud.hideAnimated(true)
        }, failure: { (request, error) -> Void in
            hud.hideAnimated(true)
        });
        
        ApiAI.sharedApiAI().enqueue(request)
    }
}
