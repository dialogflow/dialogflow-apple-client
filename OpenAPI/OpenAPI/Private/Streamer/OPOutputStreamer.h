//
//  OutputStreamer.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/9/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPOutputStreamer;

@protocol OPOutputStreamerDelegate <NSObject>

@required
- (void)startedOutputStreamer:(OPOutputStreamer *)outputStreamer;
- (void)endedOutputStreamer:(OPOutputStreamer *)outputStreamer;

- (void)outputStreamer:(OPOutputStreamer *)outputStreamer didFailWithError:(NSError *)error;

@end

@interface OPOutputStreamer : NSObject

@property(nonatomic, assign) id <OPOutputStreamerDelegate> delegate;
@property(nonatomic, strong, readonly, getter = getResultData) NSData *resultData;

- (id)init DEPRECATED_ATTRIBUTE;
- (id)initWithStream:(NSOutputStream *)stream;
- (void)appendData:(NSData *)data;

- (void)closeStream;
- (void)applyAndClose;

@end
