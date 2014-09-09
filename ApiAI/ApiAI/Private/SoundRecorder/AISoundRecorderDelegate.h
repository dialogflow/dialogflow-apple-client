//
//  SoundRecorderDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/14/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <CoreAudio/CoreAudioTypes.h>

@class AISoundRecorder;

@protocol AISoundRecorderDelegate <NSObject>

@optional

- (void)willStartSoundRecorder:(AISoundRecorder *)soundRecorder;
- (void)didStopSoundRecorder:(AISoundRecorder *)soundRecorder;

@required

//This method called async
- (void)soundRecorder:(AISoundRecorder *)soundRecorder
         receivedData:(AudioBufferList *)data
    andNumberOfFrames:(UInt32)numberofFrames;

@end
