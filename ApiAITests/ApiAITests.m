//
//  ApiAITests.m
//  ApiAITests
//
//  Created by Kuragin Dmitriy on 12/02/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ApiAI.h"
#import "AIDefaultConfiguration.h"

@interface ApiAITests : XCTestCase

@property(nonatomic, strong) ApiAI *apiai;

@end

@implementation ApiAITests

- (void)setUp {
    [super setUp];
    
    ApiAI *apiai = [ApiAI sharedApiAI];
    
    AIDefaultConfiguration *configuration = [[AIDefaultConfiguration alloc] init];
    
    configuration.clientAccessToken = @"09604c7f91ce4cd8a4ede55eb5340b9d";
    configuration.subscriptionKey = @"4c91a8e5-275f-4bf0-8f94-befa78ef92cd";
    
    [apiai setConfiguration:configuration];
    
    apiai.lang = @"en";
    
    self.apiai = apiai;
}

- (void)testHello
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handle response"];
 
    NSString *query = @"Hello";
    
    AITextRequest *textRequest = (AITextRequest *)[_apiai requestWithType:AIRequestTypeText];
    
    textRequest.query = query;
    
    [textRequest setCompletionBlockSuccess:^(AIRequest *request, NSDictionary *response) {
        NSDictionary *result = response[@"result"];
        
        XCTAssertTrue([[query lowercaseString] isEqualToString:[result[@"resolvedQuery"] lowercaseString]]);
        
        XCTAssertTrue([result[@"action"] isEqualToString:@"greeting"]);
        
        XCTAssertTrue([result[@"speech"] isEqualToString:@"Hi! How are you?"]);
        
        [expectation fulfill];
    } failure:^(AIRequest *request, NSError *error) {
        XCTAssert(NO, @"Can't response error");
        [expectation fulfill];
    }];
    
    [_apiai enqueue:textRequest];
    
    [self waitForExpectationsWithTimeout:60
                                 handler:^(NSError *error) {
                                     XCTAssertNil(error, @"Error");
                                 }];
}

- (void)testContexts
{
    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Handle response"];
        
        NSString *query = @"What is your name?";
        
        AITextRequest *textRequest = (AITextRequest *)[_apiai requestWithType:AIRequestTypeText];
        
        textRequest.query = query;
        
        [textRequest setCompletionBlockSuccess:^(AIRequest *request, NSDictionary *response) {
            NSDictionary *result = response[@"result"];
            
            XCTAssertTrue([[query lowercaseString] isEqualToString:[result[@"resolvedQuery"] lowercaseString]]);
            XCTAssertTrue([result[@"action"] isEqualToString:@"name"]);
            
            NSArray *contexts = result[@"contexts"];
            
            XCTAssertNotNil(contexts);
            
            XCTAssertTrue([contexts count] == 1);
            
            NSDictionary *context = [contexts firstObject];
            
            XCTAssertTrue([context[@"name"] isEqualToString:@"name_question"]);
            
            XCTAssertTrue([context[@"parameters"] count] == 1);
            
            
            [expectation fulfill];
        } failure:^(AIRequest *request, NSError *error) {
            XCTAssert(NO, @"Can't response error");
        }];
        
        [_apiai enqueue:textRequest];
        
        [self waitForExpectationsWithTimeout:60
                                     handler:^(NSError *error) {
                                         XCTAssertNil(error, @"Error");
                                     }];
    }
    
    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Handle response"];
        
        AITextRequest *textRequest = (AITextRequest *)[_apiai requestWithType:AIRequestTypeText];
        
        textRequest.resetContexts = NO;
        
        textRequest.query = @"Hello";
        
        [textRequest setCompletionBlockSuccess:^(AIRequest *request, NSDictionary *response) {
            NSArray *contexts = response[@"result"][@"contexts"];
            
            XCTAssertNotNil(contexts);
            
            XCTAssertTrue([contexts count] == 1);
            
            NSDictionary *context = [contexts firstObject];
            
            XCTAssertTrue([context[@"name"] isEqualToString:@"name_question"]);
            
            XCTAssertTrue([context[@"parameters"] count] == 1);
            
            [expectation fulfill];
        } failure:^(AIRequest *request, NSError *error) {
            XCTAssert(NO, @"Can't response error");
        }];
        
        [_apiai enqueue:textRequest];
        
        [self waitForExpectationsWithTimeout:60
                                     handler:^(NSError *error) {
                                         XCTAssertNil(error, @"Error");
                                     }];
    }
    
    {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Handle response"];
        
        AITextRequest *textRequest = (AITextRequest *)[_apiai requestWithType:AIRequestTypeText];
        
        textRequest.resetContexts = YES;
        
        textRequest.query = @"Hello";
        
        [textRequest setCompletionBlockSuccess:^(AIRequest *request, NSDictionary *response) {
            NSArray *contexts = response[@"result"][@"contexts"];
            
            XCTAssertTrue([contexts count] == 0);
            
            [expectation fulfill];
        } failure:^(AIRequest *request, NSError *error) {
            XCTAssert(NO, @"Can't response error");
        }];
        
        [_apiai enqueue:textRequest];
        
        [self waitForExpectationsWithTimeout:60
                                     handler:^(NSError *error) {
                                         XCTAssertNil(error, @"Error");
                                     }];
    }
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
