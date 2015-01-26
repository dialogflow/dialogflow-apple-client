//
//  SettingsTableViewController.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Settings.h"

@interface SettingsTableViewController ()

@property(nonatomic, copy) NSArray *settings;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settings = [Settings sharedSettings].settings;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *setting = _settings[indexPath.row];
    
    cell.textLabel.text = setting[@"language"];
    
    if ([[Settings sharedSettings].selectedSetting isEqualToDictionary:setting]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *setting = _settings[indexPath.row];
    [Settings sharedSettings].selectedSetting = setting;
    
    [tableView reloadData];
}

@end
