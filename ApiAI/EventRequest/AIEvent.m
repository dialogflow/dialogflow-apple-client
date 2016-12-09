//
//  AIEvent.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 09/12/2016.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIEvent.h"

@implementation AIEvent

- (instancetype)initWithEvent:(NSString *)event andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.event = event;
        self.data = data;
    }
    
    return self;
}

- (instancetype)initWithEvent:(NSString *)event {
    self = [super init];
    if (self) {
        self.event = event;
        self.data = nil;
    }
    return self;
}

@end
