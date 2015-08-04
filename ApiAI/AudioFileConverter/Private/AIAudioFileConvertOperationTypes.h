//
//  AIAudioFileConvertOperationTypes.h
//  AudioConverterAAC
//
//  Created by Kuragin Dmitriy on 04/08/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#include "AIDataProcessInfo.hpp"

OSStatus AIEncoderDataProc(AudioConverterRef inAudioConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription **outDataPacketDescription, void *inUserData);

void AIThrowIfError(OSStatus status, NSString *message);

#define AIXThrowIfError(status, message)    \
    do {                                    \
        AIThrowIfError(status, message);    \
    } while(0);