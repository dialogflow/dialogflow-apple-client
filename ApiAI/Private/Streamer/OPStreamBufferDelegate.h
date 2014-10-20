//
//  StreamBufferDelegate.h
//  StreamTest
//
//  Created by Kuragin Dmitriy on 14/10/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

@class OPStreamBuffer;

@protocol OPStreamBufferDelegate <NSObject>

@optional
- (void)willOpenStreamBuffer:(OPStreamBuffer *)streamBuffer;
- (void)didOpenStreamBuffer:(OPStreamBuffer *)streamBuffer;
- (void)willCloseStreamBuffer:(OPStreamBuffer *)streamBuffer;
- (void)didCloseStreamBuffer:(OPStreamBuffer *)streamBuffer;

- (void)streamBuffer:(OPStreamBuffer *)streamBuffer error:(NSError *)error;

@end