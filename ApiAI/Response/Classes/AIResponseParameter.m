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
