//
//  Settings.m
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "Settings.h"

#import <ApiAI/ApiAI.h>
#import <ApiAI/AIDefaultConfiguration.h>

@interface  Settings ()

@property(nonatomic, copy) NSArray *settings;

@end

@implementation Settings

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(Settings);

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Settings" ofType:@"plist"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error = nil;
        
        NSArray *settings =
        [NSPropertyListSerialization propertyListWithData:data
                                                  options:0
                                                   format:nil
                                                    error:&error];
        
        NSAssert(!error, @"Error loading settings file");
        
        self.settings = settings;
    }
    
    return self;
}

- (void)setSelectedSetting:(NSDictionary *)selectedSetting
{
    [self willChangeValueForKey:@"selectedSetting"];
    
    _selectedSetting = selectedSetting;
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = selectedSetting[@"clientAccessToken"];
    configuration.baseURL = [NSURL URLWithString:@"https://dev.api.ai/api/"];
    apiai.lang = selectedSetting[@"lang"];
    
    apiai.configuration = configuration;
    
    [self didChangeValueForKey:@"selectedSetting"];
}

@end
