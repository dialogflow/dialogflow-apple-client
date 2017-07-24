//
//  AIOriginalRequest.h
//  ApiAI
//
//  Created by Dmitrii Kuragin on 7/21/17.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AINullabilityDefines.h"

@interface AIOriginalRequest : NSObject

- (AI_NONNULL instancetype)initWithSource:(NSString * __AI_NULLABLE)source
                       andData:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)data;

@property(nonatomic, copy, readonly, AI_NULLABLE) NSString *source;
@property(nonatomic, copy, readonly, AI_NULLABLE) NSDictionary AI_GENERICS_2(NSString *, id) *data;

@end
