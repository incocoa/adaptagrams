//
//  LAJunction.m
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import "LAJunction.h"
#import "LARouter.h"
#import "libavoid.h"


@implementation LAJunction
@synthesize junctionRef = _junctionRef;

#pragma mark - Initialization and deallocation

- (id)initWithRouter:(LARouter*)router rectangle:(CGRect)rect angle:(CGFloat)angle
{
    self = [super init];
    if (self) {
        _router = [router retain];
        _junctionRef = new Avoid::JunctionRef((Avoid::Router*)[router routerRef], Avoid::Point(CGRectGetMidX(rect), CGRectGetMidY(rect)));
        ((Avoid::JunctionRef*)_junctionRef)->setPositionFixed(true);
    }
    return self;
}

- (void)dealloc
{
    ((Avoid::Router*)[_router routerRef])->deleteJunction((Avoid::JunctionRef*)_junctionRef);
    [_router release];
    [super dealloc];
}

#pragma mark - Operations

- (void)moveToRectangle:(CGRect)rect angle:(CGFloat)angle
{
    ((Avoid::Router*)[_router routerRef])->moveJunction((Avoid::JunctionRef*)_junctionRef, Avoid::Point(CGRectGetMidX(rect), CGRectGetMidY(rect)));
}

@end
