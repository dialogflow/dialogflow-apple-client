//
//  ResultNavigationController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit

class ResultNavigationController: UINavigationController {
    var response: AnyObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resultViewController = self.viewControllers.first! as! ResultViewController
        resultViewController.response = self.response
    }
}
