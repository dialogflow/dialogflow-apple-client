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

#import "AIAudioFileConvertOperationTypes.h"

OSStatus AIEncoderDataProc(AudioConverterRef inAudioConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription **outDataPacketDescription, void *inUserData)
{
    AIDataProcessInfo *dataProcessInfo = (AIDataProcessInfo *)inUserData;
    
    UInt32 maxPackets = dataProcessInfo->getBufferSize() / dataProcessInfo->getSizePerPacket();
    if (*ioNumberDataPackets > maxPackets) *ioNumberDataPackets = maxPackets;
    
    UInt32 ioNumBytes = dataProcessInfo->getBufferSize();
    OSStatus status =
    AudioFileReadPacketData(
                            dataProcessInfo->getSourceFileID(),
                            false,
                            &ioNumBytes,
                            dataProcessInfo->getPacketDescriptions(),
                            dataProcessInfo->getOffset(),
                            ioNumberDataPackets,
                            dataProcessInfo->getBuffer()
                            );
    
    ioData->mBuffers[0].mData = dataProcessInfo->getBuffer();
    ioData->mBuffers[0].mDataByteSize = ioNumBytes;
    ioData->mBuffers[0].mNumberChannels = 1;
    
    dataProcessInfo->increaseOffset(*ioNumberDataPackets);
    
    *outDataPacketDescription = dataProcessInfo->getPacketDescriptions();
    
    if (status == kAudioFileEndOfFileError) {
        status = noErr;
    }
    
    return status;
}

void AIThrowIfError(OSStatus status, NSString *message) {
    if (status != noErr) {
        NSDictionary *userInfo = @{
                                   @"OSStatus": @(status)
                                   };
        
        [[NSException exceptionWithName:@"Wrong operation status" reason:message userInfo:userInfo] raise];
    }
}