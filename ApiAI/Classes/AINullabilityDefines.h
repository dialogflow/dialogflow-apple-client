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

    #define AI_NULLABLE
    #define AI_NONNULL

    #define __AI_NULLABLE
    #define __AI_NONNULL

    #define __AI_NULL_UNSPECIFIED

#else

    #if __has_attribute(_Nonnull) && __has_attribute(_Nullable)

        #define AI_NULLABLE Nullable
        #define AI_NONNULL Nonnull

        #define __AI_NULLABLE _Nullable
        #define __AI_NONNULL _Nonnull

        #define __AI_NULL_UNSPECIFIED _Null_unspecified

    #else

        #define AI_NULLABLE nullable
        #define AI_NONNULL nonnull

        #define __AI_NULLABLE __nullable
        #define __AI_NONNULL __nonnull

        #define __AI_NULL_UNSPECIFIED __null_unspecified

    #endif

#endif

#if __has_feature(objc_generics)

    #define AI_GENERICS_1(a1) <a1>
    #define AI_GENERICS_2(a1, a2) <a1, a2>
    #define AI_GENERICS_3(a1, a2, a3) <a1, a2, a3>
    #define AI_GENERICS_4(a1, a2, a3, a4) <a1, a2, a3, a4>
    #define AI_GENERICS_5(a1, a2, a3, a4, a5) <a1, a2, a3, a4, a5>

#else

    #define AI_GENERICS_1(a1)
    #define AI_GENERICS_2(a1, a2)
    #define AI_GENERICS_3(a1, a2, a3)
    #define AI_GENERICS_4(a1, a2, a3, a4)
    #define AI_GENERICS_5(a1, a2, a3, a4, a5)

#endif

#define AI_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#define AI_DEPRECATED_MSG_ATTRIBUTE(msg) __attribute((deprecated((msg))))

#endif
