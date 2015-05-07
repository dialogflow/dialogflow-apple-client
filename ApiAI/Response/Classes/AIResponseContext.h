//
//  AIResponseContext.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 07/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIResponseContext : NSObject

- (instancetype)init __unavailable;

@property(nonatomic, copy, readonly) NSString *name;
@property(nonatomic, copy, readonly) NSDictionary *parameters;

@end
