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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ApiAI.h"
#import "AIDefaultConfiguration.h"
#import "AIResponse.h"
#import "AIRequestEntity.h"
#import "AIUserEntitiesRequest.h"

@interface UserEntitiesTests : XCTestCase

@property(nonatomic, strong) ApiAI *apiai;

@property(nonatomic, strong, readonly) AIResponse *response;
@property(nonatomic, strong, readonly) NSDate *timestamp;

@end

@implementation UserEntitiesTests

- (void)setUp {
    [super setUp];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AIDefaultConfiguration *configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"09604c7f91ce4cd8a4ede55eb5340b9d";
    configuration.subscriptionKey = @"4c91a8e5-275f-4bf0-8f94-befa78ef92cd";
    
    //    configuration.baseURL = [NSURL URLWithString:@"https://dev.api.ai/api"];
    
    [apiai setConfiguration:configuration];
    
    apiai.lang = @"en";
    
    self.apiai = apiai;
}

- (void)testUploadUserEntities
{
    XCTestExpectation *expectationUploadUserEntities = [self expectationWithDescription:@"Upload user entities."];
    
    AIUserEntitiesRequest *request = [_apiai userEntitiesRequest];
    
    
    
    AIUserEntity *entity = [[AIUserEntity alloc] initWithName:@"Application"
                                                   andEntries:@[
                                                                [[AIRequestEntry alloc] initWithValue:@"Firefox"
                                                                                          andSynonims:@[@"Firefox"]],
                                                                [[AIRequestEntry alloc] initWithValue:@"XCode"
                                                                                          andSynonims:@[@"XCode"]],
                                                                [[AIRequestEntry alloc] initWithValue:@"Sublime Text"
                                                                                          andSynonims:@[@"Sublime Text"]],
                                                                ]
                                                    andExtend:NO];
    
    request.entities = @[entity];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        [expectationUploadUserEntities fulfill];
    } failure:^(AIRequest *request, NSError *error) {
        XCTAssert(NO, @"Upload user entities with error.");
        [expectationUploadUserEntities fulfill];
    }];
    
    [_apiai enqueue:request];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"Error");
                                 }];
    
    XCTestExpectation *expectationRequest = [self expectationWithDescription:@"Try to use uploaded user entity."];
    
    NSString *query = @"Open application XCode";
    
    AITextRequest *textRequest = [_apiai textRequest];
    
    textRequest.query = query;
    
    [textRequest setCompletionBlockSuccess:^(AIRequest *request, NSDictionary *response) {
        NSDictionary *result = response[@"result"];
        
        XCTAssertTrue([[query lowercaseString] isEqualToString:[result[@"resolvedQuery"] lowercaseString]]);
        
        XCTAssertTrue([result[@"action"] isEqualToString:@"open_application"]);
        
        XCTAssertTrue(result[@"parameters"], @"parameters should be defined");
        XCTAssertTrue(result[@"parameters"][@"application"], @"Parameter application shoulde be defined");
        XCTAssertTrue([result[@"parameters"][@"application"] isEqualToString:@"XCode"], @"Parameter application shoulde be equal XCode");
        
        [expectationRequest fulfill];
    } failure:^(AIRequest *request, NSError *error) {
        XCTAssert(NO, @"Can't response error");
        [expectationRequest fulfill];
    }];
    
    [_apiai enqueue:textRequest];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"Error");
                                 }];

}

@end
