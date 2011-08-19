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

#pragma mark - Initialization and deallocation

- (id)init
{
    self = [super init];
    if (self) {
        _routerRef = new Avoid::Router(Avoid::PolyLineRouting | Avoid::OrthogonalRouting);
        ((Avoid::Router*)_routerRef)->setRoutingOption(Avoid::nudgeOrthogonalSegmentsConnectedToShapes, true);
        ((Avoid::Router*)_routerRef)->setTransactionUse(true);
        ((Avoid::Router*)_routerRef)->setRoutingPenalty(Avoid::segmentPenalty, Avoid::noPenalty);
        ((Avoid::Router*)_routerRef)->setRoutingPenalty(Avoid::anglePenalty, Avoid::noPenalty);
    }
    return self;
}

- (void)dealloc
{
    delete (Avoid::Router*)_routerRef;
    [super dealloc];
}

#pragma mark - Properties

- (BOOL)useTransactions
{
    return ((Avoid::Router*)_routerRef)->transactionUse();
}

- (void)setUseTransactions:(BOOL)useTransactions
{
    ((Avoid::Router*)_routerRef)->setTransactionUse(useTransactions);
}

- (BOOL)nudgeOrthogonalSegmentsConnectedToShapes
{
    return ((Avoid::Router*)_routerRef)->routingOption(Avoid::nudgeOrthogonalSegmentsConnectedToShapes);
}

- (void)setNudgeOrthogonalSegmentsConnectedToShapes:(BOOL)nudgeOrthogonalSegmentsConnectedToShapes
{
    ((Avoid::Router*)_routerRef)->setRoutingOption(Avoid::nudgeOrthogonalSegmentsConnectedToShapes, nudgeOrthogonalSegmentsConnectedToShapes);
}

- (double)orthogonalNudgeDistance
{
    return ((Avoid::Router*)_routerRef)->orthogonalNudgeDistance();
}

- (void)setOrthogonalNudgeDistance:(double)orthogonalNudgeDistance
{
    ((Avoid::Router*)_routerRef)->setOrthogonalNudgeDistance(orthogonalNudgeDistance);
}

#pragma mark - Operations

- (void)processTransaction
{
    ((Avoid::Router*)_routerRef)->processTransaction();
}

@end
