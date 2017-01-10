//
//  AIEvent.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 09/12/2016.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIEvent.h"

@implementation AIEvent

- (instancetype)initWithName:(NSString *)name andData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.name = name;
        self.data = data;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.data = nil;
    }
    return self;
}

@end
