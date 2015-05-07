//
//  AIResponseParameter.m
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIResponseParameter.h"
#import "AIResponseParameter_Private.h"
#import "AIDatePeriodFormatter.h"

@interface AIResponseParameter ()

@property(nonatomic, copy) NSString *string;

@end

@implementation AIResponseParameter

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        self.string = string;
        
        _stringValue = self.string;
        
        [self prepareValues];
    }
    return self;
}

- (void)prepareValues
{
    [self prepareDateValue];
    [self prepareDatePeriodValue];
}

- (void)prepareDateValue
{
    NSArray *dateFormats = @[
                             @"yyyy-MM-dd",
                             @"HH:mm:ss",
                             @"yyyy-MM-dd'T'HH:mm:ssZ",
                             ];
    
    NSArray *dateFormatters = [self dateFormattersForDateFormats:dateFormats];
    
    __block NSDate *date = nil;
    
    NSString *dateString = self.string;
    
    [dateFormatters enumerateObjectsUsingBlock:^(NSDateFormatter *dateFormatter, NSUInteger idx, BOOL *stop) {
        date = [dateFormatter dateFromString:dateString];
        if (date) {
            *stop = YES;
        }
    }];
    
    _dateValue = date;
}

- (void)prepareDatePeriodValue
{
    NSArray *dateFormats = @[
                             @"yyyy-MM-dd",
                             @"HH:mm:ss",
                             @"yyyy-MM-dd'T'HH:mm:ssZ",
                             ];
    
    NSArray *datePeriodFormatters = [self datePeriodFormattersForDateFormatters:[self dateFormattersForDateFormats:dateFormats]];
    
    __block NSArray *datePeriod = nil;
    
    NSString *datePeriodString = self.string;
    
    [datePeriodFormatters enumerateObjectsUsingBlock:^(AIDatePeriodFormatter *datePeriodFormatter, NSUInteger idx, BOOL *stop) {
        datePeriod = [datePeriodFormatter datesFromString:datePeriodString];
        if (datePeriod) {
            *stop = YES;
        }
    }];
    
    _datePeriodValue = datePeriod;
}

- (NSArray *)dateFormattersForDateFormats:(NSArray *)dateFormats
{
    NSMutableArray *dateFormatters = [NSMutableArray arrayWithCapacity:dateFormats.count];
    
    [dateFormats enumerateObjectsUsingBlock:^(NSString *dateFormat, NSUInteger idx, BOOL *stop) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:locale];
        
        [dateFormatter setDateFormat:dateFormat];
        
        [dateFormatters addObject:dateFormatter];
    }];
    
    return [dateFormatters copy];
}

- (NSArray *)datePeriodFormattersForDateFormatters:(NSArray *)dateFormatters
{
    NSMutableArray *datePeriodFormatters = [NSMutableArray arrayWithCapacity:dateFormatters.count];
    
    [dateFormatters enumerateObjectsUsingBlock:^(NSDateFormatter *dateFormatter, NSUInteger idx, BOOL *stop) {
        AIDatePeriodFormatter *datePeriodFormatter = [[AIDatePeriodFormatter alloc] init];
        datePeriodFormatter.fromDateFormatter = dateFormatter;
        datePeriodFormatter.toDateFormatter = dateFormatter;
        [datePeriodFormatters addObject:datePeriodFormatter];
    }];
    
    return [datePeriodFormatters copy];
}

@end
