//
//  AISessionIdentifierStorage.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 02/03/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AISessionIdentifierStorage : NSObject

+ (instancetype)sharedAISessionIdentifierStorage;

@property(nonatomic, copy, readonly) NSString *defaulSessionIdentifier;

+ (NSString *)defaulSessionIdentifier;

@end
