//
//  AISessionIdentifierStorage.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 02/03/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AISessionIdentifierStorage.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const kUniqueIdentifierKey = @"kUniqueIdentifierKey";

@interface AISessionIdentifierStorage ()

@end

@implementation AISessionIdentifierStorage {
    NSString *_defaulSessionIdentifier;
}

+ (instancetype)sharedAISessionIdentifierStorage
{
    static AISessionIdentifierStorage *apiAI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiAI = [[AISessionIdentifierStorage alloc] init];
    });
    
    return apiAI;
}

+ (NSString *)defaulSessionIdentifier
{
    return [AISessionIdentifierStorage sharedAISessionIdentifierStorage].defaulSessionIdentifier;
}

- (NSString *)defaulSessionIdentifier
{
    if (!_defaulSessionIdentifier) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (![userDefaults objectForKey:kUniqueIdentifierKey]) {
            [userDefaults setObject:[[NSUUID UUID] UUIDString] forKey:kUniqueIdentifierKey];
            [userDefaults synchronize];
        }
        
        NSString *vendorIdentifier = [userDefaults objectForKey:kUniqueIdentifierKey];
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        _defaulSessionIdentifier = [self md5FromString:[NSString stringWithFormat:@"%@:%@", vendorIdentifier, bundleIdentifier]];
    }
    
    return _defaulSessionIdentifier;
}

- (NSString *)md5FromString:(NSString *)string
{
    const char *concat_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
