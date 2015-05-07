//
//  AIResponseMetadata.h
//  AIWrapRespProject
//
//  Created by Kuragin Dmitriy on 06/05/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIResponseMetadata : NSObject

@property(nonatomic, copy, readonly) NSString *indentId;
@property(nonatomic, copy, readonly) NSString *intentName;

- (instancetype)init __unavailable;

@end
