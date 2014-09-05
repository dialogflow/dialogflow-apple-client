//
//  OPVoiceRequest.m
//  OpenAPI
//
//  Created by Kuragin Dmitriy on 25/06/14.
//  Copyright (c) 2014 Kuragin Dmitriy. All rights reserved.
//

#import "OPVoiceRequest.h"
#import "OPDataService.h"
#import "OPRecordDetector.h"
#import "OPOutputStreamer.h"

#import "AFNetworking.h"

@class OPRecordDetector;

@interface OPVoiceRequest () <NSStreamDelegate, OPRecordDetectorDelegate, OPOutputStreamerDelegate>

@property(nonatomic, strong) NSOutputStream *output;
@property(nonatomic, strong) NSInputStream *input;
@property(nonatomic, strong) OPRecordDetector *recordDetector;
@property(nonatomic, strong) OPOutputStreamer *outputStreamer;
@property(nonatomic, copy) NSString *boundary;

@end

@implementation OPVoiceRequest

- (instancetype)initWithDataService:(OPDataService *)dataService
{
    self = [super initWithDataService:dataService];
    if (self) {
        self.recordDetector = [[OPRecordDetector alloc] init];
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
    
//    [_output write:[data bytes] maxLength:[data length]];
    
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

- (void)recordDetector:(OPRecordDetector *)helper didReceiveData:(NSData *)data power:(float)power
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_outputStreamer appendData:data];
    });
}

- (void)recordDetectorDidStartRecording:(OPRecordDetector *)helper
{

}

- (void)recordDetectorDidStopRecording:(OPRecordDetector *)helper cancelled:(BOOL)cancelled
{
    [_outputStreamer appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [_outputStreamer applyAndClose];
}

- (void)recordDetector:(OPRecordDetector *)helper didFailWithError:(NSError *)error
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
