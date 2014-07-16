//
//  SoundRecorderDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/14/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <CoreAudio/CoreAudioTypes.h>

@class OPSoundRecorder;

@protocol OPSoundRecorderDelegate <NSObject>

@optional

- (void)willStartSoundRecorder:(OPSoundRecorder *)soundRecorder;
- (void)didStopSoundRecorder:(OPSoundRecorder *)soundRecorder;

@required

//This method called async
- (void)soundRecorder:(OPSoundRecorder *)soundRecorder
         receivedData:(AudioBufferList *)data
    andNumberOfFrames:(UInt32)numberofFrames;

@end
