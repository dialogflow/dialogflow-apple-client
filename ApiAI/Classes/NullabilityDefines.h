//
//  NullabilityDefines.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 22/06/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

#ifndef ApiAI_NullabilityDefines_h
#define ApiAI_NullabilityDefines_h

#if ! __has_feature(nullability)
#define nullable
#define nonnull

#define __nullable
#define __nonnull
#endif

#endif
