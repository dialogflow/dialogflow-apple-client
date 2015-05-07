//
//  DatePeriodFormatter.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIDatePeriodFormatter : NSFormatter

@property(nonatomic, copy) NSString *splitString;
@property(nonatomic, strong) NSDateFormatter *fromDateFormatter;
@property(nonatomic, strong) NSDateFormatter *toDateFormatter;

- (NSArray *)datesFromString:(NSString *)periodString;
- (NSString *)stringFromDates:(NSArray *)dates;

@end
