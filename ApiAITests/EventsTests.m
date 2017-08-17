/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import <XCTest/XCTest.h>

#import "ApiAI.h"
#import "AIDefaultConfiguration.h"
#import "AIResponse.h"
#import "AIRequestEntity.h"
#import "AIUserEntitiesRequest.h"

@interface EventsTests : XCTestCase

@property(nonatomic, strong) ApiAI *apiai;

@end


@implementation EventsTests

- (void)setUp {
    [super setUp];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AIDefaultConfiguration *configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"09604c7f91ce4cd8a4ede55eb5340b9d";
    
    [apiai setConfiguration:configuration];
    
    apiai.lang = @"en";
    
    self.apiai = apiai;
}

- (void)testEvents {
    XCTestExpectation *expectationEventRequest = [self expectationWithDescription:@"Event request."];
    
    AIEventRequest *eventRequest = _apiai.eventRequest;
    
    eventRequest.event = [[AIEvent alloc] initWithName:@"my_custom_event"];
    
    [eventRequest setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
        XCTAssert([response.result.action isEqualToString:@"my_custom_event.some_action"], @"error");
        
        [expectationEventRequest fulfill];
    } failure:^(AIRequest *request, NSError *error) {
        XCTAssert(NO, @"Send event request with error.");
        [expectationEventRequest fulfill];
    }];
    
    [_apiai enqueue:eventRequest];
    
    [self waitForExpectationsWithTimeout:60 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Error");
    }];
}

@end
