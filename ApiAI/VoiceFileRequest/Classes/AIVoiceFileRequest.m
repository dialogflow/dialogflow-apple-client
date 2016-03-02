//
//  AIVoiceFileRequest.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIVoiceFileRequest.h"
#import "AIVoiceFileRequest_Private.h"
#import "AIStreamBuffer.h"
#import "AIQueryRequest+Private.h"
#import "AIDataService_Private.h"
#import "AIResponseConstants.h"
#import "AIRequest_Private.h"

@interface AIVoiceFileRequest () <NSStreamDelegate>

@property(nonatomic, strong) NSOutputStream *output;
@property(nonatomic, strong) NSInputStream *input;
@property(nonatomic, strong) AIStreamBuffer *streamBuffer;
@property(nonatomic, copy) NSString *boundary;

@end

@implementation AIVoiceFileRequest

- (instancetype)initWithDataService:(AIDataService *)dataService
{
    self = [super initWithDataService:dataService];
    if (self) {
        self.contentType = @"audio/wav";
    }
    
    return self;
}

- (void)configureHTTPRequest
{
    self.boundary = [self creteBoundary];
    
    AIDataService *dataService = self.dataService;
    NSMutableURLRequest *request = self.prepareDefaultRequest;
    
    NSInputStream *input = nil;
    NSOutputStream *output = nil;
    
    [[self class] createBoundInputStream:&input outputStream:&output bufferSize:2048];
    
    self.input = input;
    self.output = output;
    
    [request setHTTPBodyStream:input];
    
    NSURLSession *session = dataService.URLSession;
    
    __weak typeof(self) selfWeak = self;
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData * __AI_NULLABLE data, NSURLResponse * __AI_NULLABLE response1, NSError * __AI_NULLABLE error) {
                   if (!error) {
                       NSHTTPURLResponse *response = (NSHTTPURLResponse *)response1;
                       if ([dataService.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
                           NSError *responseSerializeError = nil;
                           id responseData =
                           [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:&responseSerializeError];
                           
                           if (!responseSerializeError) {
                               [self handleResponse:responseData];
                           } else {
                               [self handleError:responseSerializeError];
                           }
                           
                       } else {
                           NSError *responseStatusCodeError =
                           [NSError errorWithDomain:AIErrorDomain
                                               code:NSURLErrorBadServerResponse
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]
                                                      }];
                           [selfWeak handleError:responseStatusCodeError];
                       }
                   } else {
                       [selfWeak handleError:error];
                   }
               }];
    
    self.dataTask = dataTask;
    
    NSMutableData *data = [[[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    [data appendData:[@"Content-Disposition: form-data; name=\"request\"; filename=\"request.json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self requestBodyDictionary]
                                                       options:0
                                                         error:nil];
    
    [data appendData:jsonData];
    
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"voiceData\"; filename=\"recording.mp4\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", self.contentType?:@"audio/wav"];
    
    [data appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.streamBuffer = [[AIStreamBuffer alloc] initWithOutputStream:output];
    [_streamBuffer open];
    
    [dataTask resume];
    
    [_streamBuffer write:data];

    [_inputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
}

- (NSDictionary *)defaultHeaders
{
    NSMutableDictionary *headers = [[super defaultHeaders] mutableCopy];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", _boundary];
    
    headers[@"Content-Type"] = contentType;
    headers[@"Transfer-Encoding"] = @"chunked";
    
    return [headers copy];
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            uint8_t buffer[1024];
            
            NSInteger bytesRead = [_inputStream read:buffer maxLength:1024];
            
            NSData *data = [NSData dataWithBytes:&buffer length:bytesRead];
            
            [_streamBuffer write:data];
            break;
        }
        case NSStreamEventEndEncountered: {
            [_streamBuffer write:[[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [_streamBuffer flushAndClose];
            
            [_inputStream close];
            break;
        }
        case NSStreamEventErrorOccurred:
            [_inputStream close];
            break;
        default:
            break;
    }
}

- (NSString *)creteBoundary
{
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
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

- (void)dealloc
{
    [_inputStream close];
}

@end
