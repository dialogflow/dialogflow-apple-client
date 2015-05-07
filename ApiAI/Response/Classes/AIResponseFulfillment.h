//
//  AIResponseFulfillment.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIResponseFulfillment : NSObject

- (instancetype)init __unavailable;

@property(nonatomic, copy, readonly) NSString *speech;

@end
