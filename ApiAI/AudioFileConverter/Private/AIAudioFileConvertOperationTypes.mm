//
//  AIAudioFileConvertOperationTypes.m
//  AudioConverterAAC
//
//  Created by Kuragin Dmitriy on 04/08/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

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