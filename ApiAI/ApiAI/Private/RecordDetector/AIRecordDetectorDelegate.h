//
//  RecordDetectorDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AIRecordDetector;

@protocol AIRecordDetectorDelegate <NSObject>

@required

- (void)recordDetector:(AIRecordDetector *)helper didReceiveData:(NSData *)data power:(float)power;
- (void)recordDetectorDidStartRecording:(AIRecordDetector *)helper;
- (void)recordDetectorDidStopRecording:(AIRecordDetector *)helper cancelled:(BOOL)cancelled;
- (void)recordDetector:(AIRecordDetector *)helper didFailWithError:(NSError *)error;

@end