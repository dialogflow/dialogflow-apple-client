//
//  DataProcessInfo.cpp
//  AudioConverterAAC
//
//  Created by Kuragin Dmitriy on 04/08/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

#include "AIDataProcessInfo.hpp"

AIDataProcessInfo::AIDataProcessInfo(UInt32 sizePerPacket, AudioFileID sourceFileID) : sizePerPacket(sizePerPacket), sourceFileID(sourceFileID)
{
    buffer = (char *)malloc(sizeof(char) * AI_BUFFER_SIZE);
    buffer_size = AI_BUFFER_SIZE;
    outputPacketDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * AI_BUFFER_SIZE / sizePerPacket);
    
    offset = 0;
}

UInt32 AIDataProcessInfo::getSizePerPacket()
{
    return sizePerPacket;
}

AudioFileID AIDataProcessInfo::getSourceFileID()
{
    return sourceFileID;
}

void AIDataProcessInfo::increaseOffset(SInt64 shift)
{
    offset += shift;
}

SInt64 AIDataProcessInfo::getOffset()
{
    return offset;
}

char *AIDataProcessInfo::getBuffer()
{
    return buffer;
}

int AIDataProcessInfo::getBufferSize()
{
    return  buffer_size;
}

AudioStreamPacketDescription *AIDataProcessInfo::getPacketDescriptions()
{
    return outputPacketDescriptions;
}

AIDataProcessInfo::~AIDataProcessInfo()
{
    free(buffer);
    free(outputPacketDescriptions);
}