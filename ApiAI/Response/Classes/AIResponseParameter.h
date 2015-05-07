//
//  AIResponseParameter.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIResponseParameter : NSObject

- (instancetype)init __unavailable;

@property(nonatomic, copy, readonly) NSString *stringValue;

@property(nonatomic, copy, readonly) NSArray *datePeriodValue;
@property(nonatomic, copy, readonly) NSDate *dateValue;

@end
