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