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

#import "InterfaceController.h"
#import <ApiAI/ApiAI.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController() <WCSessionDelegate>

@property(nonatomic, weak) IBOutlet WKInterfaceButton *button;
@property(nonatomic, weak) IBOutlet WKInterfaceImage *progressImage;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)didAppear
{

}

- (IBAction)doAction:(id)sender
{
    NSArray <WKAlertAction *> *actions =
  @[
    [WKAlertAction actionWithTitle:@"Text message"
                             style:WKAlertActionStyleDefault
                           handler:^{
                               [self sendTextRequest];
                           }],
    [WKAlertAction actionWithTitle:@"Voice message"
                             style:WKAlertActionStyleDefault
                           handler:^{
                               [self sendVoiceRequest];
                           }],
    [WKAlertAction actionWithTitle:@"Cancel"
                             style:WKAlertActionStyleCancel
                           handler:^{
                               
                           }],
    ];
    
    [self presentAlertControllerWithTitle:@"Choose action"
                                  message:nil
                           preferredStyle:WKAlertControllerStyleActionSheet
                                  actions:actions];
}

- (void)sendTextRequest
{
    NSArray <NSString *> * suggestions = @[
                                           @"Hello",
                                           @"How are you?"
                                           ];
    [self presentTextInputControllerWithSuggestions:suggestions
                                   allowedInputMode:WKTextInputModePlain
                                         completion:^(NSArray * _Nullable results) {
                                             if (results.count) {
                                                 [self showProgress];
                                                 
                                                 ApiAI *apiai = [ApiAI sharedApiAI];
                                                 
                                                 AITextRequest *textRequest = [apiai textRequest];
                                                 
                                                 textRequest.query = @[results.firstObject];
                                                 
                                                 [textRequest setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
                                                     NSString *text = response.result.fulfillment.speech;
                                                     
                                                     if (![text length]) {
                                                         text = @"<empty response>";
                                                     }
                                                     
                                                     [self.button setTitle:text];
                                                     
                                                     [self dismissProgress];
                                                 } failure:^(AIRequest *request, NSError *error) {
                                                     [self.button setTitle:[error localizedDescription]];
                                                     [self dismissProgress];
                                                 }];
                                                 
                                                 [apiai enqueue:textRequest];
                                             }
                                         }];

}

- (void)sendVoiceRequest
{
    if ([WCSession isSupported]) {
        [WCSession defaultSession].delegate = self;
        [[WCSession defaultSession] activateSession];
    }
    
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,YES);
    NSString *path = [[filePaths firstObject] stringByAppendingPathComponent:@"recording.mp4"];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    
    NSDictionary *options = @{
                              WKAudioRecorderControllerOptionsMaximumDurationKey: @(10.f)
                              };
    
    [self presentAudioRecorderControllerWithOutputURL:fileUrl
                                               preset:WKAudioRecorderPresetWideBandSpeech
                                              options:options
                                           completion:^(BOOL didSave, NSError * _Nullable error) {
                                               if (didSave && !error) {
                                                   [self showProgress];
                                                   
                                                   ApiAI *apiai = [ApiAI sharedApiAI];
                                                   
                                                   AIVoiceFileRequest *request = [apiai voiceFileRequestWithFileURL:fileUrl];
                                                   
                                                   [request setMappedCompletionBlockSuccess:^(AIRequest *request, AIResponse *response) {
                                                       NSString *text = response.result.fulfillment.speech;
                                                       
                                                       if (![text length]) {
                                                           text = @"<empty response>";
                                                       }
                                                       
                                                       [self.button setTitle:text];
                                                       
                                                       [self dismissProgress];
                                                   } failure:^(AIRequest *request, NSError *error) {
                                                       [self.button setTitle:[error localizedDescription]];
                                                       [self dismissProgress];
                                                   }];
                                                   
                                                   [apiai enqueue:request];
                                               }
                                           }];
}

- (void)session:(nonnull WCSession *)session didFinishFileTransfer:(nonnull WCSessionFileTransfer *)fileTransfer error:(nullable NSError *)error
{
    NSLog(@"");
}

- (void)showProgress
{
    [_button setHidden:YES];
    [_progressImage setHidden:NO];
    [_progressImage startAnimating];
}

- (void)dismissProgress
{
    [_button setHidden:NO];
    [_progressImage setHidden:YES];
    [_progressImage stopAnimating];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



