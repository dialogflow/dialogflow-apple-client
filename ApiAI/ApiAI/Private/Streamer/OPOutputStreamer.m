//
//  OutputStreamer.m
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/9/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "OPOutputStreamer.h"

@interface OPOutputStreamer() <NSStreamDelegate>

@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) dispatch_queue_t mutex; // this created for using OutputStreamer in multithred code
@property(nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation OPOutputStreamer
{
    NSUInteger byteIndex;
    dispatch_once_t onceToken;
}

- (id)init
{
    self = [super init];
    if(self) {
    
    }
    return self;
}

- (id)initWithStream:(NSOutputStream *)stream
{
    self = [super init];
    if (self) {
        byteIndex = 0;
        self.outputStream = stream;
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
    dispatch_sync(_mutex, ^{
        if ([_outputStream hasSpaceAvailable]) {
            NSUInteger data_len = [_data length];
            
            NSInteger len = ((data_len - byteIndex >= 1024) ?
                                1024 : (data_len - byteIndex));
            
            if (len != 0) {
                NSData *sendData = [_data subdataWithRange:NSMakeRange(byteIndex, len)];
                
                len = [_outputStream write:[sendData bytes] maxLength:len];
                
                if (len >= 0) {
                    byteIndex += len;
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
            [self writeData];
            
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate outputStreamer:self didFailWithError:[_outputStream streamError]];
            });
            break;
        }
        
        default:
        break;
    }
}

- (void)applyAndClose
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSInteger len = 0;
        do {
            NSUInteger data_len = [_data length];
            len = ((data_len - byteIndex >= 1024) ?
                             1024 : (data_len - byteIndex));
        } while (len);
        
        [self closeStream];
    });
}

- (void)closeStream
{
    dispatch_sync(_mutex, ^{
        [_outputStream close];
        [_outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    });
}

- (NSData *)getResultData
{
    __block NSData *resultData = nil;
    dispatch_sync(_mutex, ^{
        resultData = [_data copy];
    });
    
    return resultData;
}

- (void)dealloc
{
    [self closeStream];
}

@end

