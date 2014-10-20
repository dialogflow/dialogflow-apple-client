//
//  StreamBuffer.h
//  StreamTest
//
//  Created by Kuragin Dmitriy on 14/10/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPStreamBufferDelegate.h"

@interface OPStreamBuffer : NSObject

- (instancetype)init __unavailable;
- (instancetype)initWithOutputStream:(NSOutputStream *)outputStream;

@property(nonatomic, weak) id <OPStreamBufferDelegate> delegate;

- (void)open;
- (void)write:(NSData *)data;
- (void)close;
- (void)flushAndClose;

@end
