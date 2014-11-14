/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2014 by Speaktoit, Inc. (https://www.speaktoit.com)
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

@interface ApiAI ()

@end

@implementation ApiAI

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(ApiAI);

@synthesize configuration=_configuration;

- (AIRequest *)requestWithType:(AIRequestType)requestType
{
    AIRequest *request = nil;
    if (requestType == AIRequestTypeText) {
        request = [[AITextRequest alloc] initWithDataService:_dataService];
    } else {
        request = [[AIVoiceRequest alloc] initWithDataService:_dataService];
    }
    
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

- (void)enqueue:(AIRequest *)request
{
    [_dataService enqueueRequest:request];
}

- (NSString *)lang
{
    if (!_lang) {
        _lang = [[NSLocale preferredLanguages] firstObject]?:@"en";
    }
    
    return _lang;
}

@end
