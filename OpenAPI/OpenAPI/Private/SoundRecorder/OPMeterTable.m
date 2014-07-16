//
//  MeterTable.m
//  Assistant
//
//  Created by Dmitriy Kuragin on 11/12/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

#import "OPMeterTable.h"
#import "OPAudioUtils.h"

#define kMinDBvalue -80.f
#define kTableSize 400
#define kRoot 2.f

@implementation OPMeterTable
{
    float mMinDecibels;
    float mDecibelResolution;
    float mScaleFactor;
    
    float *mTable;
}

- (id)init
{
    self = [super init];
    if (self) {
        mMinDecibels = kMinDBvalue;
        mDecibelResolution = mMinDecibels / (kTableSize - 1);
        mScaleFactor = 1 / mDecibelResolution;
        
        mTable = (float *)malloc(kTableSize * sizeof(float));
        
        double minAmp = OPDbToAmpMy(mMinDecibels);
        double ampRange = 1. - minAmp;
        double invAmpRange = 1. / ampRange;
        
        double rroot = 1. / kRoot;
        for (size_t i = 0; i < kTableSize; ++i) {
            double decibels = i * mDecibelResolution;
            double amp = OPDbToAmpMy(decibels);
            double adjAmp = (amp - minAmp) * invAmpRange;
            mTable[i] = pow(adjAmp, rroot);
        }
    }
    return self;
}

- (float)valueAt:(float)decibels
{
    if (decibels < mMinDecibels) return  0.;
    if (decibels >= 0.) return 1.;
    int index = (int)(decibels * mScaleFactor);
    return mTable[index];
}

- (void)dealloc
{
    free(mTable);
}

@end
