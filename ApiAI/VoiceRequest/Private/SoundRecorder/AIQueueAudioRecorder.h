//
//  AIQueueAudioRecorder.h
//  PartialDemo
//
//  Created by Kuragin Dmitriy on 27/01/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIQueueAudioRecorder;

@protocol AIQueueAudioRecorderDelegate <NSObject>

@required
- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder dataReceived:(SInt16 *)samples andSamplesCount:(UInt32)samplesCount;

@optional
- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder didFailWithError:(NSError *)error;
- (void)audioRecorder:(AIQueueAudioRecorder *)audioRecorder audioLevelChanged:(float)audioLevel;

@end

@interface AIQueueAudioRecorder : NSObject

@property(nonatomic, weak) IBOutlet id <AIQueueAudioRecorderDelegate> delegate;

@property(nonatomic, assign, readonly) BOOL isRecording;

- (void)start;
- (void)stop;

@end
