/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

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
    
//    [configuration setBaseURL:[NSURL URLWithString:@"https://dev.api.ai/api/"]];
//    configuration.clientAccessToken = @"92fa31b4e15c4ffca80dca2942deb6d3";
    
    configuration.clientAccessToken = selectedSetting[@"clientAccessToken"];
    configuration.subscriptionKey = selectedSetting[@"subscribtionKey"];
    apiai.lang = selectedSetting[@"lang"];
    
    apiai.configuration = configuration;
    
    [self didChangeValueForKey:@"selectedSetting"];
}

@end
