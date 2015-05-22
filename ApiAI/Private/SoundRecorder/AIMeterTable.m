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

#import "AIMeterTable.h"
#import "AIAudioUtils.h"

#define kMinDBvalue -80.f
#define kTableSize 400
#define kRoot 2.f

@implementation AIMeterTable
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
        
        double minAmp = AIDbToAmpMy(mMinDecibels);
        double ampRange = 1. - minAmp;
        double invAmpRange = 1. / ampRange;
        
        double rroot = 1. / kRoot;
        for (size_t i = 0; i < kTableSize; ++i) {
            double decibels = i * mDecibelResolution;
            double amp = AIDbToAmpMy(decibels);
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
