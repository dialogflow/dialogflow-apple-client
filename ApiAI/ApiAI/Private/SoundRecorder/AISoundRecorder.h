//
//  SoundRecorder.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "AISoundRecorderDelegate.h"

@interface AISoundRecorder : NSObject
{
@public
    AudioBufferList bufferList;
}

@property(nonatomic, weak) id <AISoundRecorderDelegate> delegate;
@property(atomic, assign) double currentPower;

- (BOOL)isRecording;
- (void)start;
- (void)stop;

@end
