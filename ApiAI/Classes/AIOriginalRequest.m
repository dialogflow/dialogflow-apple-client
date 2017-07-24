//
//  AIOriginalRequest.m
//  ApiAI
//
//  Created by Dmitrii Kuragin on 7/21/17.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

#import "AIOriginalRequest.h"
#import "AIOriginalRequest_Private.h"

@implementation AIOriginalRequest

- (AI_NONNULL instancetype)initWithSource:(NSString * __AI_NULLABLE)source
                                  andData:(NSDictionary AI_GENERICS_2(NSString *, id) * __AI_NULLABLE)data
{
    self = [super init];
    if (self) {
        _source = [source copy];
        _data = [data copy];
    }
    
    return self;
}

- (NSDictionary *)serialized {
    return @{
        @"source": _source,
        @"data": _data
    };
}

@end
