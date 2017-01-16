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
#import "AIResponseParameterConstants.h"

@interface AIResponseParameter ()

@property(nonatomic, readonly) AIResponseParameterConstants *constants;

@end

@implementation AIResponseParameter

@synthesize datePeriodValue=_datePeriodValue, dateValue=_dateValue, listValue=_listValue;

- (instancetype)initWithObject:(id <NSObject>)object
{
    self = [super init];
    if (self) {
        _constants = [AIResponseParameterConstants shared];
        _rawValue = object;
        
        [self prepareValues];
    }
    return self;
}

- (void)prepareValues
{
    [self prepareStringValue];
    [self prepareNumberValue];
    [self prepareDateValue];
    [self prepareDatePeriodValue];
    [self prepareListValue];
    [self prepareCompositeValue];
}

- (void)prepareStringValue
{
    _stringValue = [NSString stringWithFormat:@"%@", _rawValue];
}

- (void)prepareNumberValue
{
    if ([_rawValue isKindOfClass:[NSNumber class]]) {
        _numberValue = (NSNumber *)_rawValue;
    } else if ([_rawValue isKindOfClass:[NSString class]]){
        _numberValue = [self.constants.numberFormatter numberFromString:(NSString *)_rawValue];
    }
}

- (void)prepareDateValue
{
    NSArray *dateFormatters = self.constants.dateFormatters;
    
    __block NSDate *date = nil;
    
    NSString *dateString = self.stringValue;
    
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
    NSArray *datePeriodFormatters = self.constants.datePeriodFormatters;
    
    __block NSArray *datePeriod = nil;
    
    NSString *datePeriodString = self.stringValue;
    
    [datePeriodFormatters enumerateObjectsUsingBlock:^(AIDatePeriodFormatter *datePeriodFormatter, NSUInteger idx, BOOL *stop) {
        datePeriod = [datePeriodFormatter datesFromString:datePeriodString];
        if (datePeriod) {
            *stop = YES;
        }
    }];
    
    _datePeriodValue = datePeriod;
}

- (void)prepareListValue
{
    if ([_rawValue isKindOfClass:[NSArray class]]) {
        NSArray *listObject = (NSArray *)_rawValue;
        NSMutableArray AI_GENERICS_1(AIResponseParameter *) *list = [NSMutableArray array];
        
        [listObject enumerateObjectsUsingBlock:^(id __AI_NONNULL obj, NSUInteger idx, BOOL * __AI_NONNULL stop) {
            [list addObject:[[AIResponseParameter alloc] initWithObject:obj]];
        }];
        
        _listValue = [list copy];
    }
}

- (void)prepareCompositeValue {
    if ([_rawValue isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionaryObject = (NSDictionary *)_rawValue;
        NSMutableDictionary AI_GENERICS_2(NSString *, AIResponseParameter *) *composite = [NSMutableDictionary dictionary];
        
        [dictionaryObject enumerateKeysAndObjectsUsingBlock:^(NSString * __AI_NONNULL key, id  __AI_NONNULL obj, BOOL * __AI_NONNULL stop) {
            composite[key] = [[AIResponseParameter alloc] initWithObject:obj];
        }];
        
        _compositeValue = composite;
    }
}

@end
