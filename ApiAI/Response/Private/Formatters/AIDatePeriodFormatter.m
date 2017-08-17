/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
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
