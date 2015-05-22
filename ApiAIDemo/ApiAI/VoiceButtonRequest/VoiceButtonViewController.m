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

#import "VoiceButtonViewController.h"
#import "ResultNavigarionController.h"

@interface VoiceButtonViewController ()

@end

@implementation VoiceButtonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) selfWeak = self;
    
    [_voiceRequestButton setSuccessCallback:^(id response) {
        __strong typeof(selfWeak) selfStrong = selfWeak;
        
        ResultNavigarionController *resultNavigarionController = [selfStrong.storyboard instantiateViewControllerWithIdentifier:@"ResultNavigarionController"];
        resultNavigarionController.response = response;
        
        [selfStrong presentViewController:resultNavigarionController
                                 animated:YES
                               completion:NULL];
    }];
    
    [_voiceRequestButton setFailureCallback:^(NSError *error) {
        if (!([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dismiss"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

@end
