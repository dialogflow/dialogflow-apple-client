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

#import "AIVoiceRequest.h"
#import "AIDataService.h"
#import "AIRecordDetector.h"
#import "OPOutputStreamer.h"

#import "AFNetworking.h"

@class AIRecordDetector;

@interface AIVoiceRequest () <NSStreamDelegate, AIRecordDetectorDelegate, OPOutputStreamerDelegate>

@property(nonatomic, strong) NSOutputStream *output;
@property(nonatomic, strong) NSInputStream *input;
@property(nonatomic, strong) AIRecordDetector *recordDetector;
@property(nonatomic, strong) OPOutputStreamer *outputStreamer;
@property(nonatomic, copy) NSString *boundary;

@end

@implementation AIVoiceRequest

- (instancetype)initWithDataService:(AIDataService *)dataService
{
    self = [super initWithDataService:dataService];
    if (self) {
        self.recordDetector = [[AIRecordDetector alloc] init];
        _recordDetector.delegate = self;
        
        AFHTTPRequestOperationManager *manager = self.dataService.manager;
        
        NSString *path = @"query/";
        
        NSError *error = nil;
        
        self.boundary = [self creteBoundary];
        
        NSURL *baseURL = [NSURL URLWithString:@"http://192.168.1.121:8080/api/"];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                          URLString:[[NSURL URLWithString:path relativeToURL:baseURL] absoluteString]
                                                                         parameters:nil
                                                                              error:&error];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", _boundary];
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"chunked" forHTTPHeaderField:@"Transfer-Encoding"];
        [request setValue:@"Bearer e43c0g5d787787d95221c9481cw8fe98" forHTTPHeaderField:@"Authorization"];
        
        __weak typeof(self) seflWeak = self;
        
        self.HTTPRequestOperation = [manager HTTPRequestOperationWithRequest:request
                                                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                         NSLog(@"HEADERS: %@", [operation.request allHTTPHeaderFields]);
                                                                         [seflWeak handleResponse:responseObject];
                                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                         NSLog(@"RESPONSE: %@", operation.responseString);
                                                                         [seflWeak handleError:error];
                                                                     }];
        
        NSInputStream *input = nil;
        NSOutputStream *output = nil;
        
        [[self class] createBoundInputStream:&input outputStream:&output bufferSize:128];
        
        self.input = input;
        self.output = output;
        
        [_HTTPRequestOperation setInputStream:input];
        
        self.outputStreamer = [[OPOutputStreamer alloc] initWithStream:output];
        _outputStreamer.delegate = self;
    }
    
    return self;
}

- (void)configureHTTPRequest
{
    AFHTTPRequestOperationManager *manager = self.dataService.manager;
    
    [_output open];
    
    NSMutableData *data = [[[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [data appendData:[@"Content-Disposition: form-data; name=\"request\"; filename=\"request.json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"{\"agent_id\":\"chrys\"}" dataUsingEncoding:NSUTF8StringEncoding]];

    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"voiceData\"; filename=\"qwe.wav\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: audio/wav\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [manager.operationQueue addOperation:_HTTPRequestOperation];
    
    [_outputStreamer appendData:data];
    
    [_recordDetector start];
}

- (NSString *)creteBoundary
{
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];;
}

+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
    
    readStream = NULL;
    writeStream = NULL;
    
    CFStreamCreateBoundPair(
                            NULL,
                            ((inputStreamPtr  != nil) ? &readStream : NULL),
                            ((outputStreamPtr != nil) ? &writeStream : NULL),
                            (CFIndex) bufferSize
                            );
    
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = CFBridgingRelease(writeStream);
    }
}

- (void)recordDetector:(AIRecordDetector *)helper didReceiveData:(NSData *)data power:(float)power
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_outputStreamer appendData:data];
    });
}

- (void)recordDetectorDidStartRecording:(AIRecordDetector *)helper
{

}

- (void)recordDetectorDidStopRecording:(AIRecordDetector *)helper cancelled:(BOOL)cancelled
{
    [_outputStreamer appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStreamer applyAndClose];
}

- (void)recordDetector:(AIRecordDetector *)helper didFailWithError:(NSError *)error
{

}

- (void)startedOutputStreamer:(OPOutputStreamer *)outputStreamer
{

}

- (void)endedOutputStreamer:(OPOutputStreamer *)outputStreamer
{

}

- (void)outputStreamer:(OPOutputStreamer *)outputStreamer didFailWithError:(NSError *)error
{

}


@end
