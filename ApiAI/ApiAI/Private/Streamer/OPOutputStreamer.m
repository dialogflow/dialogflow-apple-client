/***********************************************************************************************************************
 *
 * API.AI iOS SDK - client-side libraries for API.AI
 * ==========================================
 *
 * Copyright (C) 2014 by Speaktoit, Inc. (https://www.speaktoit.com)
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

#import "OPOutputStreamer.h"

@interface OPOutputStreamer() <NSStreamDelegate>

@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) dispatch_queue_t mutex; // this created for using OutputStreamer in multithred code
@property(nonatomic, strong) NSOutputStream *outputStream;
@property(nonatomic, assign) NSUInteger byteIndex;

@end

@implementation OPOutputStreamer
{
    NSUInteger byteIndex;
    dispatch_once_t onceToken;
}

- (id)initWithStream:(NSOutputStream *)stream
{
    self = [super init];
    if (self) {
        self.byteIndex = 0;
        self.outputStream = stream;
        _outputStream.delegate = self;
        self.data = [NSMutableData data];
        
        self.mutex = dispatch_queue_create("ouputStramer.mutext.queue", 0);
    }
    
    return self;
}

- (void)appendData:(NSData *)data
{
    dispatch_sync(_mutex, ^{
        [_data appendData:data];
    });
    
    if ([self.outputStream hasSpaceAvailable]) {
        [self writeData];
    }
    
    dispatch_once(&onceToken, ^{
        _outputStream.delegate = self;
        [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_outputStream open];
    });
}

- (void)writeData
{
    __weak typeof(self) selfWeak = self;
    dispatch_sync(_mutex, ^{
        if ([selfWeak.outputStream hasSpaceAvailable]) {
            NSUInteger data_len = [selfWeak.data length];
            
            NSInteger len = ((data_len - selfWeak.byteIndex >= 1024) ?
                             1024 : (data_len - selfWeak.byteIndex));
            
            if (len != 0) {
                NSData *sendData = [_data subdataWithRange:NSMakeRange(selfWeak.byteIndex, len)];
                
                len = [selfWeak.outputStream write:[sendData bytes] maxLength:len];
                
                if (len >= 0) {
                    selfWeak.byteIndex += len;
                }
            }
        }
    });
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate startedOutputStreamer:self];
            });
            break;
        }
            
        case NSStreamEventHasSpaceAvailable:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self writeData];
            });
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            [self closeStream];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate endedOutputStreamer:self];
            });
            break;
        }
            
        case NSStreamEventErrorOccurred: {
            [self closeStream];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate outputStreamer:self didFailWithError:[_outputStream streamError]];
            });
            break;
        }
            
        default:
            [self closeStream];
            break;
    }
}

- (void)closeStream
{
    dispatch_sync(_mutex, ^{
        [_outputStream close];
        [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_data setData:nil];
    });
}

- (void)applyAndClose
{
    __weak typeof(self) selfWeak = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger len = 0;
        NSStreamStatus status = [_outputStream streamStatus];
        do {
            status = [_outputStream streamStatus];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [selfWeak writeData];
            });
            NSUInteger data_len = [selfWeak.data length];
            len = ((data_len - selfWeak.byteIndex >= 1024) ?
                   1024 : (data_len - selfWeak.byteIndex));
        } while (len > 0 && status == NSStreamStatusOpen);
        
        [selfWeak closeStream];
    });
}

- (NSData *)getResultData
{
    __weak typeof(self) selfWeak = self;
    __block NSData *resultData = nil;
    dispatch_sync(_mutex, ^{
        resultData = [selfWeak.data copy];
    });
    
    return resultData;
}

- (void)dealloc
{
    [self closeStream];
}

@end

