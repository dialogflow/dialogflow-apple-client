//
//  AIEventRequest.h
//  ApiAI
//
//  Created by Kuragin Dmitriy on 09/12/2016.
//  Copyright © 2016 Kuragin Dmitriy. All rights reserved.
//

#import "AIQueryRequest.h"
#import "AIEvent.h"

@interface AIEventRequest : AIQueryRequest

@property(nonatomic, strong) AIEvent *event;

@end
