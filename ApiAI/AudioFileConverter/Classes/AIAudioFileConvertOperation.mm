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

#import "AIAudioFileConvertOperation.h"
#import "AIAudioFileConvertOperationTypes.h"

@interface AIAudioFileConvertOperation ()

@property(nonatomic, assign) AudioFileID sourceFileID;
@property(nonatomic, assign) AudioFileID destinationFileID;

@property(nonatomic, assign) AudioStreamBasicDescription sourceStreamDescription;
@property(nonatomic, assign) AudioStreamBasicDescription destinationStreamDescription;

@property(nonatomic, assign) AudioStreamBasicDescription actualSourceStreamDescription;
@property(nonatomic, assign) AudioStreamBasicDescription actualDestinationStreamDescription;

@property(nonatomic, assign) AudioConverterRef audioConverter;

@end

@implementation AIAudioFileConvertOperation

- (instancetype)initWithSourceFileURL:(NSURL *)sourceFileURL andDestinationFileURL:(NSURL *)destinationFileURL
{
    self = [super init];
    if (self) {
        _sourceFileURL = sourceFileURL;
        _destinationFileURL = destinationFileURL;
        
        AudioStreamBasicDescription destination;
        
        destination.mFormatID = kAudioFormatLinearPCM;
        destination.mSampleRate = 16000.f;
        destination.mBytesPerPacket = 2;
        destination.mChannelsPerFrame = 1;
        destination.mBitsPerChannel = 16;
        destination.mBytesPerPacket = destination.mBytesPerFrame = 2 * destination.mChannelsPerFrame;
        destination.mFramesPerPacket = 1;
        destination.mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger;
        
        _destinationStreamDescription = destination;
    }
    
    return self;
}

- (void)main
{
    @try {
        AIXThrowIfError(AudioFileOpenURL((__bridge CFURLRef)_sourceFileURL, kAudioFileReadPermission, 0, &_sourceFileID), @"Cannot Open Source File");
        
        AudioStreamBasicDescription source;
        
        UInt32 size = sizeof(source);
        AudioFileGetProperty(_sourceFileID, kAudioFilePropertyDataFormat, &size, &source);
        
        _sourceStreamDescription = source;
        
        AIXThrowIfError(AudioFileCreateWithURL((__bridge CFURLRef)_destinationFileURL,
                                               kAudioFileWAVEType,
                                               &_destinationStreamDescription,
                                               kAudioFileFlags_EraseFile,
                                               &_destinationFileID), @"Cannot Open Destination File");
        
        AIXThrowIfError(AudioConverterNew(&_sourceStreamDescription,
                                          &_destinationStreamDescription,
                                          &_audioConverter), @"Cannot create AudioConverter");
        
        {
            AudioStreamBasicDescription actualSourceStreamDescription;
            UInt32 size = sizeof(actualSourceStreamDescription);
            AIXThrowIfError(AudioConverterGetProperty(_audioConverter,
                                                      kAudioConverterCurrentInputStreamDescription,
                                                      &size,
                                                      &actualSourceStreamDescription), @"Cannot get actual source description");
            _actualSourceStreamDescription = actualSourceStreamDescription;
        }
        
        {
            AudioStreamBasicDescription actualDestinationStreamDescription;
            UInt32 size = sizeof(actualDestinationStreamDescription);
            AIXThrowIfError(AudioConverterGetProperty(_audioConverter,
                                                      kAudioConverterCurrentOutputStreamDescription,
                                                      &size,
                                                      &actualDestinationStreamDescription), @"Cannot get actual destination description")
            _actualDestinationStreamDescription = actualDestinationStreamDescription;
        }
        
        UInt32 sizePerPacket;
        
        size = sizeof(sizePerPacket);
        AIXThrowIfError(AudioFileGetProperty(_sourceFileID,
                                             kAudioFilePropertyPacketSizeUpperBound,
                                             &size,
                                             &sizePerPacket), @"Cannot get packet size from sourcef file");
        
        AIDataProcessInfo dataProcessInfo(sizePerPacket, _sourceFileID);
        
        SInt64 outputFilePos = 0;
        
        while (true) {
            AudioBufferList fillBufList;
            fillBufList.mNumberBuffers = 1;
            fillBufList.mBuffers[0].mNumberChannels = _actualDestinationStreamDescription.mChannelsPerFrame;
            
            char *buffer = (char *)malloc(sizeof(char) * AI_BUFFER_SIZE);
            fillBufList.mBuffers[0].mDataByteSize = AI_BUFFER_SIZE / _actualDestinationStreamDescription.mBytesPerPacket;
            fillBufList.mBuffers[0].mData = buffer;
            
            UInt32 ioOutputDataPackets = AI_BUFFER_SIZE / _actualDestinationStreamDescription.mBytesPerPacket;
            
            AIXThrowIfError(AudioConverterFillComplexBuffer(_audioConverter,
                                                            AIEncoderDataProc,
                                                            (void *)&dataProcessInfo,
                                                            &ioOutputDataPackets,
                                                            &fillBufList,
                                                            NULL), @"Cannot Fill Audio Converter");
            
            AIXThrowIfError(AudioFileWritePackets(_destinationFileID,
                                                  false,
                                                  fillBufList.mBuffers[0].mDataByteSize,
                                                  NULL,
                                                  outputFilePos,
                                                  &ioOutputDataPackets,
                                                  buffer), @"Cannot Write Data To Destination File");
            
            outputFilePos += ioOutputDataPackets;
            
            free(buffer);
            
            if (ioOutputDataPackets == 0 || [self isCancelled]) break;
        }
    }
    @catch (NSException *exception) {
        NSDictionary *exceptionUserInfo = exception.userInfo;
        
        NSString *message = @"Unknown error";
        
        if (exception.reason) {
            message = exception.reason;
        }
        
        NSInteger code = -1; // Unknown error
        
        if (exceptionUserInfo[@"OSStatus"]) {
            code = [exceptionUserInfo[@"OSStatus"] integerValue];
        }
        
        NSDictionary *errorUserInfo = @{
                                        NSLocalizedDescriptionKey: message
                                        };
        
        NSError *error = [NSError errorWithDomain:@"ApiAiErrorDomain" code:code
                                         userInfo:errorUserInfo];
        
        [self willChangeValueForKey:@"error"];
        _error = error;
        [self didChangeValueForKey:@"error"];
        
        [super main];
    }
    @finally {
        if (_audioConverter) AudioConverterDispose(_audioConverter);
        if (_sourceFileID) AudioFileClose(_sourceFileID);
        if (_destinationFileID) AudioFileClose(_destinationFileID);
        
        [super main];
    }
}

@end
