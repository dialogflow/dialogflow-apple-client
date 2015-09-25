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
    
    configuration.clientAccessToken = @"b316a120a0ab4383980746032c21c4f5";
    configuration.subscriptionKey = @"4c91a8e5-275f-4bf0-8f94-befa78ef92cd";
    
    [ApiAI sharedApiAI].configuration = configuration;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
