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
    
    @IBAction func sendText(_ sender: UIButton)
    {
        let hud = MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        
        self.textField?.resignFirstResponder()
        
        let request = ApiAI.shared().textRequest()
        
        if let text = self.textField?.text {
            request?.query = [text]
        } else {
            request?.query = [""]
        }
        
        request?.setCompletionBlockSuccess({[unowned self] (request, response) -> Void in
            let resultNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultNavigationController
            
            resultNavigationController.response = response as AnyObject?
            
            self.present(resultNavigationController, animated: true, completion: nil)
            
            hud.hide(animated: true)
        }, failure: { (request, error) -> Void in
            hud.hide(animated: true)
        });
        
        ApiAI.shared().enqueue(request)
    }
}
