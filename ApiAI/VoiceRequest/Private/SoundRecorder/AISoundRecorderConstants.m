/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2015 by Speaktoit, Inc. (https://www.speaktoit.com)
 * https://www.api.ai
 *
 ***********************************************************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 ***********************************************************************************************************************/

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
UInt32 const kFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;

#pragma mark -
#pragma mark AudioComponentDescription Constants

OSType const kComponentType = kAudioUnitType_Output;
OSType const kComponentSubType = kAudioUnitSubType_RemoteIO;
OSType const kComponentManufacturer = kAudioUnitManufacturer_Apple;
UInt32 const kComponentFlags = 0;
UInt32 const kComponentFlagsMask = 0;

#pragma mark -