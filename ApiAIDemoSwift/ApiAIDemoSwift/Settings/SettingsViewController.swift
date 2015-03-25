//
//  SettingsViewController.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

import UIKit;

class SettingsViewController: UITableViewController {
    let settings = Settings.sharedSettings.settings
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell;
        
        let settings = self.settings[indexPath.row]
        
        cell.textLabel?.text = settings["language"]
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Settings.sharedSettings.selectedSettings = self.settings[indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
