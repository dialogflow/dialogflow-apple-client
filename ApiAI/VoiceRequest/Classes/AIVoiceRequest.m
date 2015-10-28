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

#import "AIVoiceRequest.h"
#import "AIDataService.h"
#import "AIRecordDetector.h"
#import "AIStreamBuffer.h"
#import "AIDataService_Private.h"
#import "AIConfiguration.h"
#import "AIRequestEntity_Private.h"
#import "AIRequest+Private.h"

#import "AIResponseConstants.h"

@class AIRecordDetector;

@interface AIVoiceRequest () <NSStreamDelegate, AIRecordDetectorDelegate>

@property(nonatomic, strong) NSOutputStream *output;
@property(nonatomic, strong) NSInputStream *input;
@property(nonatomic, strong) AIRecordDetector *recordDetector;
@property(nonatomic, strong) AIStreamBuffer *streamBuffer;
@property(nonatomic, copy) NSString *boundary;

@end

@implementation AIVoiceRequest

- (instancetype)initWithDataService:(AIDataService *)dataService
{
    self = [super initWithDataService:dataService];
    if (self) {
        self.recordDetector = [[AIRecordDetector alloc] init];
        _recordDetector.delegate = self;
        
        self.useVADForAutoCommit = YES;
        
        self.boundary = [self creteBoundary];
        
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
        
        
        self.streamBuffer = [[AIStreamBuffer alloc] initWithOutputStream:output];
        [_streamBuffer open];
    }
    return self;
}

- (NSDictionary *)defaultHeaders
{
    NSMutableDictionary *headers = [[super defaultHeaders] mutableCopy];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", _boundary];
    
    headers[@"Content-Type"] = contentType;
    headers[@"Transfer-Encoding"] = @"chunked";
    
    return [headers copy];
}

- (void)configureHTTPRequest
{
    NSMutableData *data = [[[NSString stringWithFormat:@"--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    NSString *timeZoneString = self.timeZone ? self.timeZone.name : [NSTimeZone localTimeZone].name;
    
    NSMutableDictionary *parameters = [@{
                                         @"lang": self.lang,
                                         @"timezone": timeZoneString
                                         } mutableCopy];
    
    if (self.resetContexts) {
        parameters[@"resetContexts"] = @(self.resetContexts);
    }
    
    if ([self.entities count]) {
        NSMutableArray *entities = [NSMutableArray array];
        [self.entities enumerateObjectsUsingBlock:^(AIRequestEntity *obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:obj.dictionaryPresentation];
        }];
        
        parameters[@"entities"] = [entities copy];
    }
    
    parameters[@"sessionId"] = self.sessionId;

    [data appendData:[@"Content-Disposition: form-data; name=\"request\"; filename=\"request.json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: application/json\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:0
                                                         error:nil];
    
    [data appendData:jsonData];

    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"voiceData\"; filename=\"qwe.wav\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: audio/wav\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [self.dataTask resume];
    
    [_streamBuffer write:data];

    [_recordDetector start];
}

- (void)setUseVADForAutoCommit:(BOOL)useVADForAutoCommit
{
    _useVADForAutoCommit = useVADForAutoCommit;
    self.recordDetector.VADListening = useVADForAutoCommit;
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
    if (self.soundLevelHandleBlock) {
        _soundLevelHandleBlock(self, power);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_streamBuffer write:data];
    });
}

- (void)recordDetectorDidStartRecording:(AIRecordDetector *)helper
{
    if (self.soundRecordBeginBlock) {
        self.soundRecordBeginBlock(self);
    }
}

- (void)recordDetectorDidStopRecording:(AIRecordDetector *)helper cancelled:(BOOL)cancelled
{
    [self commitVoice];
    
    if (self.soundRecordEndBlock) {
        self.soundRecordEndBlock(self);
    }
}

- (void)commitVoice
{
    [_recordDetector stop];
    
    [_streamBuffer write:[[NSString stringWithFormat:@"\r\n--%@--\r\n", _boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [_streamBuffer flushAndClose];
}

- (void)recordDetector:(AIRecordDetector *)helper didFailWithError:(NSError *)error
{
    [self handleError:error];
}


@end
