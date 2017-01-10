//
//  AIVoiceFileRequest.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 28/07/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import "AIQueryRequest.h"

/*!
 API.AI speech recognition is going to be deprecated soon.
 Use Google Cloud Speech API or other solutions.
 
 This is request type available only for old paid plans.
 It doesn't working for new users.
 
 Will be removed on 1 Feb 2016.
 */
AI_DEPRECATED_MSG_ATTRIBUTE("Will be removed on 1 Feb 2016.")
@interface AIVoiceFileRequest : AIQueryRequest

@property(nonatomic, copy) NSString *contentType AI_DEPRECATED_ATTRIBUTE;

@end
