//
//  AlgorithmDetectorTypes.h
//  Assistant
//
//  Created by Dmitriy Kuragin on 10/16/13.
//  Copyright (c) 2013 SpeakToIt. All rights reserved.
//

typedef enum _AIAlgorithmDetectorResult {
    OPAlgorithmDetectorResultContinue = 0,
    OPAlgorithmDetectorResultNoSpeech = 1,
    OPAlgorithmDetectorResultTerminate = 3,
} AIAlgorithmDetectorResult;