//
//  AIEvent.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 09/12/2016.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIEvent : NSObject

@property(nonatomic, copy) NSString *event;
@property(nonatomic, copy) NSDictionary *data;

- (instancetype)initWithEvent:(NSString *)event andData:(NSDictionary *)data;
- (instancetype)initWithEvent:(NSString *)event;

@end
