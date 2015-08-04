//
//  AudioFileConvertOperation.h
//  AudioConverterAAC
//
//  Created by Kuragin Dmitriy on 04/08/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIAudioFileConvertOperation : NSOperation

- (instancetype)initWithSourceFileURL:(NSURL *)sourceFileURL andDestinationFileURL:(NSURL *)destinationFileURL;

@property(nonatomic, copy, readonly) NSURL *sourceFileURL;
@property(nonatomic, copy, readonly) NSURL *destinationFileURL;

@property(nonatomic, copy, readonly) NSError *error;

@end
