/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "AudioFileReader.h"

@interface AudioFileReader()

@property(nonatomic, copy) NSURL *localFileURL;
@property(nonatomic, assign) AudioStreamBasicDescription localAudioStreamBasicDescription;
@property(nonatomic, assign) ExtAudioFileRef audioFileRef;

@end

@implementation AudioFileReader

- (id)initWithFileURL:(NSURL *)fileURL
{
    if (self = [super init]) {
        self.localFileURL = fileURL;
        OSStatus status = ExtAudioFileOpenURL((__bridge CFURLRef)_localFileURL, &_audioFileRef);
        if (status != noErr) {
            [[NSException exceptionWithName:@"Error open audio file"
                                    reason:[NSString stringWithFormat:@"Error open audio file \"%@\" with status code \"%d\"", _localFileURL, (int)status]
                                   userInfo:@{}] raise];
        }
    }
    return self;
}

- (AudioStreamBasicDescription)audioStreamBasicDescription
{
    AudioStreamBasicDescription audioStreamBasicDescription;
    UInt32 descSize = sizeof(AudioStreamBasicDescription);
    
    ExtAudioFileGetProperty(_audioFileRef, kExtAudioFileProperty_FileDataFormat, &descSize, &audioStreamBasicDescription);
    
    return audioStreamBasicDescription;
}

- (Float64)sampleRate
{
    return self.audioStreamBasicDescription.mSampleRate;
}

- (SInt64)framesCount
{
    SInt64 framesCount = 0;
    UInt32 size = sizeof(SInt64);
    ExtAudioFileGetProperty(_audioFileRef, kExtAudioFileProperty_FileLengthFrames, &size, &framesCount);
    
    return framesCount;
}

- (OSStatus)read:(AudioBufferList *)inputAudioBufferList withFramesCount:(UInt32)famesCount
{
    AudioBufferList audioBufferList;
    audioBufferList.mNumberBuffers = 1;
    audioBufferList.mBuffers[0].mNumberChannels = self.audioStreamBasicDescription.mChannelsPerFrame;
    audioBufferList.mBuffers[0].mDataByteSize = famesCount * sizeof(SInt16);
    audioBufferList.mBuffers[0].mData = (void *)malloc(sizeof(SInt16) * famesCount);
    
    OSStatus status = ExtAudioFileRead(_audioFileRef, &famesCount, &audioBufferList);
    
    if (status == noErr) {
        *inputAudioBufferList = audioBufferList;
    }
    
    return status;
}

- (void)enqueueAudioBufferList:(AudioBufferList *)inputAudioBufferList
{
    free(inputAudioBufferList->mBuffers[0].mData);
}

@end
