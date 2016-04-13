//
//  AIQueryRequest.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 02/03/16.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AIRequest.h"

@interface AIQueryRequestLocation : NSObject

@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

+ (instancetype)locationWithLatitude:(double)latitude andLongitude:(double)longitude;

@end

@interface AIQueryRequest : AIRequest

/*!
 
 @property version
 
 @discussion current version of apiai, default upper version.
 
 */

@property(nonatomic, copy) NSString *version;

/*!
 
 @property contexts
 
 @discussion array of strings - List of contexts for the query that are enforced from the client. Default in nil.
 
 */

@property(nonatomic, copy) NSArray AI_GENERICS_1(NSString *) *contexts DEPRECATED_MSG_ATTRIBUTE("Use requestContexts");

/*!
 
 @property requestContexts
 
 @discussion array of context objects - List of contexts for the query that are enforced from the client. Default in nil.
 
 */

@property(nonatomic, copy) NSArray AI_GENERICS_1(AIRequestContext *) *requestContexts;

/*!
 
 @property entities
 
 @discussion array of entity objects - List of entities for the query that are enforced from the client. Default in nil.
 
 */
@property(nonatomic, copy) NSArray AI_GENERICS_1(AIRequestEntity *) *entities;

/*!
 
 @property resetContexts
 
 @discussion Possible values: YES, NO. Add new contexts to the active contexts or forget old contexts and use only supplied with the query. Default is NO.
 
 */
@property(nonatomic, assign) BOOL resetContexts;

/*!
 
 @property sessionId
 
 @discussion A string token up to 36 symbols long, used to identify the client and to manage contexts per client. Default is md5 checksum from identifierForVendor + bundleIdentifier (maximum length 36 symbols)
 
 */
@property(nonatomic, copy) NSString *sessionId;

/*!
 
 @property lang
 
 @discussion Language of current client. Default is ApiAI lang propery.
 
 */
@property(nonatomic, copy) NSString *lang;

/*!
 
 @property timeZone
 
 @discussion Current timezone. Default system timetoze.
 
 */
@property(nonatomic, copy) NSTimeZone *timeZone;

/*!
 
 @property location
 
 @discussion Current user location. Default nil.
 
 */
@property(nonatomic, strong) AIQueryRequestLocation *location;

@end
