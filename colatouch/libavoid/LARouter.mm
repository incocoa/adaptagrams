//
//  LARouter.m
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import "LARouter.h"
#import "LAShape.h"
#import "libavoid.h"


@implementation LARouter
@synthesize routerRef = _routerRef;

- (id)init
{
    return [self initWithFlags:LARouterWithOrthogonalRouting];
}

- (id)initWithFlags:(LARouterFlag)flags
{
    self = [super init];
    if (self) {
        // Convert the flags.
        Avoid::RouterFlag convertedFlags;
        switch (flags) {
            case LARouterWithPolyLineRouting:
                convertedFlags = Avoid::PolyLineRouting;
                break;
            default:
                convertedFlags = Avoid::OrthogonalRouting;
                break;
        }
        
        // Create the class.
        _routerRef = new Avoid::Router(convertedFlags);
    }
    return self;
}

- (void)dealloc
{
    delete (Avoid::Router*)_routerRef;
    [super dealloc];
}

@end
