//
//  RecordDetectorDelegate.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/13/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPRecordDetector;

@protocol OPRecordDetectorDelegate <NSObject>

@required

- (void)recordDetector:(OPRecordDetector *)helper didReceiveData:(NSData *)data power:(float)power;
- (void)recordDetectorDidStartRecording:(OPRecordDetector *)helper;
- (void)recordDetectorDidStopRecording:(OPRecordDetector *)helper cancelled:(BOOL)cancelled;
- (void)recordDetector:(OPRecordDetector *)helper didFailWithError:(NSError *)error;

@end