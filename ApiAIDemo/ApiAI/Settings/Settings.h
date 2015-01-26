//
//  Settings.h
//  ApiAIDemo
//
//  Created by Kuragin Dmitriy on 26/01/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CWLSynthesizeSingleton/CWLSynthesizeSingleton.h>

@interface Settings : NSObject

CWL_DECLARE_SINGLETON_FOR_CLASS(Settings);

@property(nonatomic, copy, readonly, getter=settings) NSArray *settings;

@property(nonatomic, copy) NSDictionary *selectedSetting;

@end
