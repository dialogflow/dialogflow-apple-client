//
//  AppDelegate.m
//  ApiAIMacOSDemo
//
//  Created by Kuragin Dmitriy on 25/09/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AppDelegate.h"
#import <ApiAI/ApiAI.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"c2a4a7a56173452e98d4824e52d0269b";
    
    [ApiAI sharedApiAI].configuration = configuration;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
