//
//  EventsTests.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 09/12/2016.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

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
