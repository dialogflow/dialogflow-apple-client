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
#import "AIResponse.h"

@interface ApiAITests : XCTestCase

@property(nonatomic, strong) ApiAI *apiai;

@property(nonatomic, strong, readonly) AIResponse *response;
@property(nonatomic, strong, readonly) NSDate *timestamp;

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
    
    
    
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"response" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:0
                                                                   error:nil];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:1430881100.2620001];
    _timestamp = timestamp;
    
    AIResponse *response = [[AIResponse alloc] initWithResponse:responseJSON];
    _response = response;
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
        
        XCTAssertTrue([result[@"fulfillment"][@"speech"] isEqualToString:@"Hi! How are you?"]);
        
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

- (void)testUpResponseFields {
    AIResponse *response = _response;
    
    XCTAssert([response.identifier isEqualToString:@"30456807-7026-4425-92af-e8918bfff944"], @"error id");
    XCTAssert([response.timestamp isEqualToDate:_timestamp], @"wrong date");
}

- (void)testStatusFields
{
    AIResponseStatus *status = _response.status;
    
    XCTAssert(status != nil, @"Status cannot be nil");
    
    XCTAssert(status.isSuccess, @"Status should be success");
    XCTAssert(status.error == nil, @"Error should be nil");
    
    XCTAssert(status.code == 200, @"Code should be 200");
    XCTAssert([status.errorType isEqualToString:@"success"], @"ErrorType should be success");
}

- (void)testResultFields
{
    AIResponseResult *result = _response.result;
    
    XCTAssert(result != nil, @"result cannot be nil");
    
    XCTAssert([result.source isEqualToString:@"agent"], @"source should be equal to 'agent'");
    
    XCTAssert([result.resolvedQuery isEqualToString:@"Hello"], @"source should be equal to 'agent'");
    XCTAssert([result.fulfillment.speech isEqualToString:@"Hi! How are you?"], @"source should be equal to 'agent'");
    XCTAssert([result.action isEqualToString:@"greeting"], @"source should be equal to 'agent'");
    
    XCTAssert(result.parameters != nil, @"parameters cannot be nil");
    XCTAssert(result.contexts != nil, @"contexts cannot be nil");
}

- (void)testMetadataFields
{
    AIResponseMetadata *metadata = _response.result.metadata;
    
    XCTAssert(metadata != nil, @"metadata cannot be nil");
    
    XCTAssert([metadata.indentId isEqualToString:@"28389ee8-e364-4eea-b928-60a80be085b7"], @"Wrong intentId");
    XCTAssert([metadata.intentName isEqualToString:@"hello"], @"Wrong intentName");
}

- (void)testDateTimePeriod
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"date-time-period"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 2, @"dates should be 2");
    XCTAssert(date == nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testDatePeriod
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"date-period"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 2, @"dates should be 2");
    XCTAssert(date == nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testTimePeriod
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"time-period"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 2, @"dates should be 2");
    XCTAssert(date == nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testDate
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"date"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 0, @"dates should be 2");
    XCTAssert(date != nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testTime
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"time"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 0, @"dates should be 2");
    XCTAssert(date != nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testLongDate
{
    NSDictionary *parameters = _response.result.parameters;
    
    AIResponseParameter *dateTimePeriod = parameters[@"longDate"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 0, @"dates should be 2");
    XCTAssert(date != nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testContextsMapping
{
    NSArray *contexts = _response.result.contexts;
    
    XCTAssertNotNil(contexts, @"Contexts connot be nil");
    XCTAssert(contexts.count == 1, @"Contexts count should be 1");
    
    AIResponseContext *context = [contexts firstObject];
    
    XCTAssertNotNil(context.parameters, @"Parameters cannot be nil");
    
    AIResponseParameter *dateTimePeriod = context.parameters[@"longDate"];
    NSArray *dates = dateTimePeriod.datePeriodValue;
    NSDate *date = dateTimePeriod.dateValue;
    NSString *string = dateTimePeriod.stringValue;
    
    XCTAssert([dates count] == 0, @"dates should be 2");
    XCTAssert(date != nil, @"date should be equal nil");
    XCTAssert(string != nil, @"string cannot be nil");
}

- (void)testMappingExtensionMethod
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handle response"];
    
    AITextRequest *textRequest = (AITextRequest *)[_apiai requestWithType:AIRequestTypeText];
    
    textRequest.resetContexts = NO;
    
    textRequest.query = @"Hello";
    
    [textRequest setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
        NSArray *contexts = response.result.contexts;

        XCTAssertNotNil(contexts);
        
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

@end
