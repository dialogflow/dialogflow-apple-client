//
//  AudioFileReader.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 11/8/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioFileReader : NSObject

- (id)init __unavailable;
- (id)initWithFileURL:(NSURL *)fileURL;

- (OSStatus)read:(AudioBufferList *)inputAudioBufferList withFramesCount:(UInt32)famesCount;

- (void)enqueueAudioBufferList:(AudioBufferList *)inputAudioBufferList;

@property(nonatomic, copy, readonly, getter = localFileURL) NSURL *fileURL;
@property(nonatomic, assign, readonly) Float64 sampleRate;
@property(nonatomic, assign, readonly) SInt64 framesCount;
@property(nonatomic, assign, readonly) AudioStreamBasicDescription audioStreamBasicDescription;

@end
