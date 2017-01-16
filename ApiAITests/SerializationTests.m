//
//  SerializationTests.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 16/01/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AIResponseParameter.h"
#import "AIResponseParameter_Private.h"

@interface SerializationTests : XCTestCase

@end

@implementation SerializationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringParameterSerialization {
    NSString *simpleStringValue = @"simple string";
    AIResponseParameter *parameter = [[AIResponseParameter alloc] initWithObject:simpleStringValue];
    
    XCTAssertTrue([parameter.stringValue isEqualToString:simpleStringValue]);
    
    XCTAssertNil(parameter.dateValue);
    XCTAssertNil(parameter.datePeriodValue);
}

- (void)testDateParameterSerialization {
    /**
     Test all available formats of date:
         yyyy-MM-dd,
         HH:mm:ss,
         yyyy-MM-dd'T'HH:mm:ssZ
    */
    
    NSString *dateStringValue = @"1970-01-01T00:00:00Z";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    
    [self validateDate:date andStringDateValue:dateStringValue];
    
    dateStringValue = @"00:00:00";
    
    [self validateDate:date andStringDateValue:dateStringValue];
    
    dateStringValue = @"1970-01-01";
    
    [self validateDate:date andStringDateValue:dateStringValue];
}

- (void)validateDate:(NSDate *)date andStringDateValue:(NSString *)dateStringValue {
    AIResponseParameter *parameter = [[AIResponseParameter alloc] initWithObject:dateStringValue];
    
    XCTAssertTrue([parameter.stringValue isEqualToString:dateStringValue]);
    
    XCTAssertTrue([parameter.dateValue isEqualToDate:date]);
    XCTAssertNil(parameter.datePeriodValue);
}

- (void)testDatePeriodParameterSerialization {
    /**
     Test all available formats of date period:
         yyyy-MM-dd/yyyy-MM-dd,
         HH:mm:ss/HH:mm:ss,
         yyyy-MM-dd'T'HH:mm:ssZ/yyyy-MM-dd'T'HH:mm:ssZ
     */
    
    NSString *datePeriodStringValue = @"1970-01-01T00:00:00Z/1970-01-01T00:00:02Z";
    NSArray *period = @[
                        [NSDate dateWithTimeIntervalSince1970:0],
                        [NSDate dateWithTimeIntervalSince1970:2]
                        ];
    
    [self validateDatePeriod:period andStringDatePeriodValue:datePeriodStringValue];
    
    datePeriodStringValue = @"00:00:00/00:00:03";
    period = @[
               [NSDate dateWithTimeIntervalSince1970:0],
               [NSDate dateWithTimeIntervalSince1970:3]
               ];
    
    [self validateDatePeriod:period andStringDatePeriodValue:datePeriodStringValue];
    
    datePeriodStringValue = @"1970-01-01/1970-01-01";
    period = @[
               [NSDate dateWithTimeIntervalSince1970:0],
               [NSDate dateWithTimeIntervalSince1970:0]
               ];
    
    [self validateDatePeriod:period andStringDatePeriodValue:datePeriodStringValue];
}

- (void)validateDatePeriod:(NSArray *)period andStringDatePeriodValue:(NSString *)datePeriodStringValue {
    AIResponseParameter *parameter = [[AIResponseParameter alloc] initWithObject:datePeriodStringValue];
    
    XCTAssertTrue([parameter.stringValue isEqualToString:datePeriodStringValue]);
    XCTAssertEqual(period.count, 2);
    XCTAssertEqual(period.count, parameter.datePeriodValue.count);
    
    XCTAssertTrue([period[0] isEqualToDate:parameter.datePeriodValue[0]]);
    XCTAssertTrue([period[1] isEqualToDate:parameter.datePeriodValue[1]]);
    
    XCTAssertNil(parameter.dateValue);
}

- (void)testListParameterSerialization {
    /**
     Sometimes server returns list of matched parameters. All of this values is should be AIResponseParameters.
     */
    
    NSArray *list = @[
                      @"simple string value",
                      @"1970-01-01", // date in format 'HH:mm:ss'
                      @"another string value",
                      @"00:00:00/00:00:03" // date period in format 'HH:mm:ss/HH:mm:ss'
                      ];
    
    AIResponseParameter *parameter = [[AIResponseParameter alloc] initWithObject:list];
    
    XCTAssertNotNil(parameter.listValue);
    
    XCTAssertNil(parameter.dateValue);
    XCTAssertNil(parameter.datePeriodValue);
    
    XCTAssertEqual(list.count, parameter.listValue.count);
    
    XCTAssertTrue([list isEqual:parameter.rawValue]);
    
    XCTAssertTrue([list[0] isEqualToString:parameter.listValue[0].stringValue]);
    XCTAssertTrue([list[2] isEqualToString:parameter.listValue[2].stringValue]);
    
    NSDate *expectedDate = [NSDate dateWithTimeIntervalSince1970:0];
    NSArray *expectedDatePeriod = @[
                                    [NSDate dateWithTimeIntervalSince1970:0],
                                    [NSDate dateWithTimeIntervalSince1970:3]
                                    ];
    
    XCTAssertTrue([parameter.listValue[1].dateValue isEqual:expectedDate]);
    XCTAssertTrue([parameter.listValue[3].datePeriodValue isEqual:expectedDatePeriod]);
}

- (void)testCompositeEntitiesParametersSerialization {
    /**
     Sometimes server receive parameters matched by composite entities. 
     Composite entities is json object or dictionary.
     */
    
    NSDictionary *composite = @{
                                @"direction": @"forward",
                                @"steps": @(5),
                                @"distance": @(12.2)
                                };
    
    AIResponseParameter *parameter = [[AIResponseParameter alloc] initWithObject:composite];
    
    XCTAssertNil(parameter.dateValue);
    XCTAssertNil(parameter.datePeriodValue);
    XCTAssertNil(parameter.listValue);
    
    XCTAssertNotNil(parameter.compositeValue);
    XCTAssertNotNil(parameter.compositeValue[@"direction"]);
    XCTAssertNotNil(parameter.compositeValue[@"direction"].stringValue);
    XCTAssertNotNil(parameter.compositeValue[@"steps"]);
    XCTAssertNotNil(parameter.compositeValue[@"steps"].numberValue);
    XCTAssertNotNil(parameter.compositeValue[@"distance"]);
    XCTAssertNotNil(parameter.compositeValue[@"distance"].numberValue);
    
    XCTAssertEqual(5, parameter.compositeValue[@"steps"].numberValue.integerValue);
    XCTAssertTrue([parameter.compositeValue[@"steps"].numberValue isEqualToNumber:@(5)]);
    
    XCTAssertTrue([@"forward" isEqualToString:parameter.compositeValue[@"direction"].stringValue]);
    
    XCTAssertTrue(ABS(12.2 - parameter.compositeValue[@"distance"].numberValue.doubleValue) < DBL_EPSILON);
    XCTAssertTrue([parameter.compositeValue[@"distance"].numberValue isEqualToNumber:@(12.2)]);
}

@end
