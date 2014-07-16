//
//  MeterTable.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 11/12/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPMeterTable : NSObject

- (float)valueAt:(float)decibels;
- (id)init;

@end
