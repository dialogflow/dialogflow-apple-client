//
//  AIVoiceFileRequest.m
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIVoiceFileRequest.h"
#import "AIVoiceFileRequest_Private.h"
#import "OPStreamBuffer.h"

@interface AIVoiceFileRequest () <NSStreamDelegate>

@property(nonatomic, strong) NSOutputStream *output;
@property(nonatomic, strong) NSInputStream *input;
@property(nonatomic, strong) OPStreamBuffer *streamBuffer;
@property(nonatomic, copy) NSString *boundary;

@end

@implementation AIVoiceFileRequest

- (void)configureHTTPRequest
{
    NSMutableURLRequest *request = self.prepareDefaultRequest;
    
    NSInputStream *input = nil;
    NSOutputStream *output = nil;
    
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
    
    
    self.streamBuffer = [[OPStreamBuffer alloc] initWithOutputStream:output];
    [_streamBuffer open];
    
//    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [_inputStream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

}

@end
