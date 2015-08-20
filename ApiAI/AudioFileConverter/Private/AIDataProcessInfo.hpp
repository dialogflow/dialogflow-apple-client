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

#ifndef DataProcessInfo_hpp
#define DataProcessInfo_hpp

#import <AudioToolbox/AudioToolbox.h>

#define AI_BUFFER_SIZE 32768

class AIDataProcessInfo {
public:
    
    AIDataProcessInfo(UInt32 sizePerPacket, AudioFileID sourceFileID);
    virtual ~AIDataProcessInfo();
    
    void increaseOffset(SInt64 shift);
    SInt64 getOffset();
    char *getBuffer();
    int getBufferSize();
    AudioStreamPacketDescription *getPacketDescriptions();
    AudioFileID getSourceFileID();
    
    UInt32 getSizePerPacket();
    
private:
    
    SInt64 offset;
    
    char *buffer;
    int buffer_size;
    
    AudioStreamPacketDescription *outputPacketDescriptions;
    
    UInt32 sizePerPacket;
    AudioFileID sourceFileID;
    
private:
    AIDataProcessInfo( const AIDataProcessInfo& ) {}
    void operator=( const AIDataProcessInfo& ) {}
};

#endif /* DataProcessInfo_hpp */
