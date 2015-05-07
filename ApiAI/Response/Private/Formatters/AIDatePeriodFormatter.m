//
//  DatePeriodFormatter.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIDatePeriodFormatter.h"

@implementation AIDatePeriodFormatter

- (NSArray *)datesFromString:(NSString *)periodString
{
    NSArray *components = [periodString componentsSeparatedByString:self.splitString];
    
    if (components.count == 2) {
        NSDate *from = [self.fromDateFormatter dateFromString:components[0]];
        NSDate *to = [self.toDateFormatter dateFromString:components[1]];
    
        if (from && to) {
            return @[from, to];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSString *)stringFromDates:(NSArray *)dates
{
    if (dates.count == 2) {
        NSString *from = [self.fromDateFormatter stringFromDate:dates[0]];
        NSString *to = [self.toDateFormatter stringFromDate:dates[1]];
        if (from && to) {
            return [@[from, to] componentsJoinedByString:self.splitString];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSString *)splitString
{
    if (!_splitString) {
        _splitString = @"/";
    }
    
    return _splitString;
}

- (NSDateFormatter *)fromDateFormatter
{
    if (!_fromDateFormatter) {
        _fromDateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _fromDateFormatter;
}

- (NSDateFormatter *)toDateFormatter
{
    if (!_toDateFormatter) {
        _toDateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _toDateFormatter;
}

@end
