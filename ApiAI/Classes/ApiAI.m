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

#import "ApiAI.h"
#import "AIDataService.h"
#import "AITextRequest.h"
#import "AIVoiceRequest.h"
#import "ApiAI_ApiAI_Private.h"
#import "AIDefaultConfiguration.h"

#import "AIConfiguration.h"
#import "AIRequest.h"

NSString *const kDefaultVersion = @"20150415";

@interface ApiAI ()

@end

@implementation ApiAI

@synthesize configuration=_configuration, version=_version;

+ (instancetype)sharedApiAI
{
    static ApiAI *apiAI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiAI = [[ApiAI alloc] init];
    });
    
    return apiAI;
}

- (AIRequest *)requestWithType:(AIRequestType)requestType
{
    AIRequest *request = nil;
    if (requestType == AIRequestTypeText) {
        request = [[AITextRequest alloc] initWithDataService:_dataService];
    } else {
        request = [[AIVoiceRequest alloc] initWithDataService:_dataService];
    }
    
    [request setVersion:self.version];
    
    [request setLang:self.lang];
    
    return request;
}

- (void)setConfiguration:(id<AIConfiguration>)configuration
{
    _configuration = configuration;
    
    self.dataService = [[AIDataService alloc] initWithConfiguration:configuration];
}

- (id <AIConfiguration>)configuration
{
    if (!_configuration) {
        _configuration = [[AIDefaultConfiguration alloc] init];
        self.dataService = [[AIDataService alloc] initWithConfiguration:_configuration];
    }
    
    return _configuration;
}

- (void)setDataService:(AIDataService *)dataService
{
    _dataService = dataService;
}

- (void)enqueue:(AIRequest *)request
{
    [_dataService enqueueRequest:request];
}

- (NSString *)version
{
    if (!_version) {
        _version = kDefaultVersion;
    }
    
    return _version;
}

- (NSString *)lang
{
    if (!_lang) {
        __block NSString *language = nil;
        
        [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLocale *locale = [NSLocale localeWithLocaleIdentifier:obj];
            
            NSString *languageCode = [locale objectForKey:NSLocaleLanguageCode];
            NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
            
            if (countryCode) {
                languageCode = [languageCode stringByAppendingFormat:@"_%@", countryCode];
            }
            
            if ([[[self class] supportedLanguages] containsObject:languageCode]) {
                language = languageCode;
                *stop = YES;
            }
        }];
        
        _lang = language?:@"en";
    }
    
    return _lang;
}

+ (NSArray *)supportedLanguages
{
    static NSArray *supportedLanguages = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        supportedLanguages = @[
                               @"en",
                               @"es",
                               @"ru",
                               @"de",
                               @"pt",
                               @"pt-BR",
                               @"es",
                               @"fr",
                               @"it",
                               @"ja",
                               @"ko",
                               @"zh-CN",
                               @"zh-HK",
                               @"zh-TW",
                               ];
    });
    
    return supportedLanguages;
}

- (void)cancellAllRequests
{
    [self.dataService.queue cancelAllOperations];
}

@end
