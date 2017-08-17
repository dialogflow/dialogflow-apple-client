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
