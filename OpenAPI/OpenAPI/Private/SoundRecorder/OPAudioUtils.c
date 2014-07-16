//
//  AudioUtils.c
//  AudioUnitPlayer
//
//  Created by Aliksandr Andrashuk on 11.11.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#include "OPAudioUtils.h"

OSStatus OPCAError(OSStatus result, const char *file, int line)
{
    if (result == noErr) return noErr;
    fprintf(stderr, "Error in %s in %d\n", file, line);
    return result;
}

inline double OPDbToAmpMy(double inDb)
{
	return pow(10., 0.05 * inDb);
}