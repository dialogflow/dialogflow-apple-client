//
//  ResultViewController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet private var textView: UITextView? = nil
    
    var response: AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView?.text = self.response?.description
    }

    @IBAction func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
