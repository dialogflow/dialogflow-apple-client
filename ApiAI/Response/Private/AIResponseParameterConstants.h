//
//  AIResponseParameterConstants.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 16/01/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AINullabilityDefines.h"
#import "AIDatePeriodFormatter.h"

@interface AIResponseParameterConstants : NSObject

@property(nonatomic, copy, readonly, getter=dateFormatters) NSArray AI_GENERICS_1(NSDateFormatter *) *dateFormatters;
@property(nonatomic, copy, readonly, getter=datePeriodFormatters) NSArray AI_GENERICS_1(AIDatePeriodFormatter *) *datePeriodFormatters;
@property(nonatomic, copy, readonly, getter=numberFormatter) NSNumberFormatter *numberFormatter;

+ (instancetype)shared;

@end
