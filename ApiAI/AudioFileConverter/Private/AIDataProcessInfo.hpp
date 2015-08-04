//
//  DataProcessInfo.hpp
//  AudioConverterAAC
//
//  Created by Kuragin Dmitriy on 04/08/15.
//  Copyright © 2015 Kuragin Dmitriy. All rights reserved.
//

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
