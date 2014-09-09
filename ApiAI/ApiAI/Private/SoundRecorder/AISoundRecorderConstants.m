//
//  SoundRecorderConstants.m
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "AISoundRecorderConstants.h"

@import CoreAudio;
@import AudioUnit;

#pragma mark -
#pragma mark AudioStreamBasicDescription Constants

Float64 const kSampleRate = 16000.f;
UInt32 const kFormatID = kAudioFormatLinearPCM;
UInt32 const kBytesPerPacket = 2;
UInt32 const kFramesPerPacket = 1;
UInt32 const kBytesPerFrame = 2;
UInt32 const kChannelsPerFrame = 1;
UInt32 const kBitsPerChannel = 16;
UInt32 const kFormatFlags = kAudioFormatFlagsCanonical;

#pragma mark -
#pragma mark AudioComponentDescription Constants

OSType const kComponentType = kAudioUnitType_Output;
OSType const kComponentSubType = kAudioUnitSubType_RemoteIO;
OSType const kComponentManufacturer = kAudioUnitManufacturer_Apple;
UInt32 const kComponentFlags = 0;
UInt32 const kComponentFlagsMask = 0;

#pragma mark -