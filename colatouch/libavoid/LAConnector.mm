//
//  LAConnector.m
//  libavoid
//
//  Created by Marcelo Boff on 11-08-19.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import "LAConnector.h"
#import "LARouter.h"
#import "LAJunction.h"
#import "libavoid.h"


@implementation LAConnector
@synthesize connectorRef = _connectorRef;

#pragma mark - Helper functions

void ConnRefCallback(void *ptr)
{
    LAConnector *connector = (LAConnector*)ptr;
    [connector setNeedsDisplay];
}

inline Avoid::ConnEnd MakeConnectorEndPoint(id<LAObstacle> obstacle, LAShapeConnectionPin connectionPin)
{
    if ([obstacle isKindOfClass:[LAJunction class]]) {
        LAJunction *junction = (LAJunction*)obstacle;
        return Avoid::ConnEnd((Avoid::JunctionRef*)[junction junctionRef]);
    }
    else {
        // Assume this is a shape.
        LAShape *shape = (LAShape*)obstacle;
        CGPoint point = [shape pointForConnectionPin:connectionPin];
        LAShapeConnectionPin direction = [shape translatedDirectionForConnectionPin:connectionPin];
        
        // Convert the values.
        Avoid::Point avoidPoint(point.x, point.y);
        Avoid::ConnDirFlag avoidDirection;
        switch (direction) {
            case LAShapeConnectionPinTop:
                avoidDirection = Avoid::ConnDirUp;
                break;
            case LAShapeConnectionPinRight:
                avoidDirection = Avoid::ConnDirRight;
                break;
            case LAShapeConnectionPinLeft:
                avoidDirection = Avoid::ConnDirLeft;
                break;
            default:
                // Assume it is down.
                avoidDirection = Avoid::ConnDirDown;
                break;
        }
        
        // Create the connection endpoint.
        return Avoid::ConnEnd(avoidPoint, avoidDirection);
    }
}
#pragma mark - Initialization and deallocation

- (id)initWithRouter:(LARouter *)router sourceObstacle:(id<LAObstacle>)sourceObstacle sourceConnectionPin:(LAShapeConnectionPin)sourceConnectionPin destObstacle:(id<LAObstacle>)destObstacle destConnectionPin:(LAShapeConnectionPin)destConnectionPin
{
    self = [super init];
    if (self) {
        _router = [router retain];
        _routeCacheRef = new Avoid::Polygon();
        
        Avoid::ConnEnd sourceEndpoint = MakeConnectorEndPoint(sourceObstacle, sourceConnectionPin);
        Avoid::ConnEnd destEndPoint = MakeConnectorEndPoint(destObstacle, destConnectionPin);
        _connectorRef = new Avoid::ConnRef((Avoid::Router*)[router routerRef], sourceEndpoint, destEndPoint);
        ((Avoid::ConnRef*)_connectorRef)->setCallback(ConnRefCallback, self);
    }
    return self;
} 

- (void)dealloc
{
    ((Avoid::Router*)[_router routerRef])->deleteConnector((Avoid::ConnRef*)_connectorRef);
    delete (Avoid::Polygon*)_routeCacheRef;
    [_router release];
    [super dealloc];
}

#pragma mark - Operations

- (void)setNeedsDisplay
{
    // Verify if the notification is bogus.
    if (!((Avoid::ConnRef*)_connectorRef)->needsRepaint()) {
        return;
    }
    
    // Copy the polygon from the display route.
    Avoid::Polygon *routeCache = (Avoid::Polygon*)_routeCacheRef;
    *routeCache = ((Avoid::ConnRef*)_connectorRef)->displayRoute();
    
    // Notify the router.
    [[_router delegate] router:_router hasNewRouteForConnector:self];
}

- (void)setEndpointsWithSourceObstacle:(id<LAObstacle>)sourceObstacle sourceConnectionPin:(LAShapeConnectionPin)sourceConnectionPin destObstacle:(id<LAObstacle>)destObstacle destConnectionPin:(LAShapeConnectionPin)destConnectionPin
{
    Avoid::ConnEnd sourceEndpoint = MakeConnectorEndPoint(sourceObstacle, sourceConnectionPin);
    Avoid::ConnEnd destEndPoint = MakeConnectorEndPoint(destObstacle, destConnectionPin);
    ((Avoid::ConnRef*)_connectorRef)->setEndpoints(sourceEndpoint, destEndPoint);
}

- (size_t)size
{
    return ((Avoid::Polygon*)_routeCacheRef)->size();
}

- (CGPoint)pointAtIndex:(size_t)index
{
    Avoid::Point point = ((Avoid::Polygon*)_routeCacheRef)->at(index);
    return CGPointMake(point.x, point.y);
}

@end
