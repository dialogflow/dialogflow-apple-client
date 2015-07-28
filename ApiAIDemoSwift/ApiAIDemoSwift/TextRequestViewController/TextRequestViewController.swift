//
//  TextRequestViewController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit
import ApiAI
import MBProgressHUD

class TextRequestViewController: UIViewController {
    @IBOutlet var textField: UITextField? = nil
    
    @IBAction func sendText(sender: UIButton)
    {
        MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        
        self.textField?.resignFirstResponder()
        
        let request = ApiAI.sharedApiAI().requestWithType(AIRequestType.Text) as! AITextRequest
        
        
        if let text = self.textField?.text {
            request.query = [text]
        } else {
            request.query = [""]
        }
        
        request.setCompletionBlockSuccess({[unowned self] (AIRequest request, AnyObject response) -> Void in
            let resultNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as! ResultNavigationController
            
            resultNavigationController.response = response
            
            self.presentViewController(resultNavigationController, animated: true, completion: nil)
            
            MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
        }, failure: { (AIRequest request, NSError error) -> Void in
            println()
            MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
        });
        
        ApiAI.sharedApiAI().enqueue(request)
    }
}
