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

#import <Foundation/Foundation.h>

@class OPOutputStreamer;

@protocol OPOutputStreamerDelegate <NSObject>

@required
- (void)startedOutputStreamer:(OPOutputStreamer *)outputStreamer;
- (void)endedOutputStreamer:(OPOutputStreamer *)outputStreamer;

- (void)outputStreamer:(OPOutputStreamer *)outputStreamer didFailWithError:(NSError *)error;

@end

@interface OPOutputStreamer : NSObject

@property(nonatomic, assign) id <OPOutputStreamerDelegate> delegate;
@property(nonatomic, strong, readonly, getter = getResultData) NSData *resultData;

- (id)init __unavailable;
- (id)initWithStream:(NSOutputStream *)stream;
- (void)appendData:(NSData *)data;

- (void)closeStream;
- (void)applyAndClose;

@end
