/**
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 

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
