/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
