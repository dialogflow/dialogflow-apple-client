//
//  AudioUtils.h
//  AudioUnitPlayer
//
//  Created by Aliksandr Andrashuk on 11.11.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#ifndef __MySpeaker__AudioUtils__
#define __MySpeaker__AudioUtils__

#define OPCA(x) OPCAError(x,__FILE__,__LINE__)

#include <stdio.h>
#include <AudioUnit/AudioUnit.h>
#include <AudioToolbox/AudioToolbox.h>

OSStatus OPCAError(OSStatus result, const char *file, int line);
double OPDbToAmpMy(double inDb);

#endif
