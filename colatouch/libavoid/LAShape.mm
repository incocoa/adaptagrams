//
//  LAShape.m
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import "LAShape.h"
#import "LARouter.h"
#import "libavoid.h"


@implementation LAShape
@synthesize shapeRef = _shapeRef;
@synthesize delegate = _delegate;

#pragma mark - Helper functions

inline CGFloat StandarizeAngle(CGFloat angle)
{
    const CGFloat fullCircle = 2.0f * M_PI;
    
    while (angle < 0)
        angle += fullCircle;
    while (angle > fullCircle)
        angle -= fullCircle;
    return angle;
}

inline CGAffineTransform MakeAffineTransform(CGRect rect, CGFloat angle)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    angle = StandarizeAngle(angle);
    if (angle != 0.0f) {
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        transform = CGAffineTransformTranslate(transform, centerPoint.x, centerPoint.y);
        transform = CGAffineTransformRotate(transform, angle);
        transform = CGAffineTransformTranslate(transform, -centerPoint.x, -centerPoint.y);
    }
    return transform;
}

#define MakeAvoidPoint(point) Avoid::Point(point.x, point.y)

inline Avoid::Polygon MakePolygon(CGRect rect, CGFloat angle)
{
    CGAffineTransform transform = MakeAffineTransform(rect, angle);
    Avoid::Polygon polygon(4);
    
    polygon.ps[0] = MakeAvoidPoint(CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)), transform));
    polygon.ps[1] = MakeAvoidPoint(CGPointApplyAffineTransform(CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)), transform));
    polygon.ps[2] = MakeAvoidPoint(CGPointApplyAffineTransform(CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)), transform));
    polygon.ps[3] = MakeAvoidPoint(CGPointApplyAffineTransform(CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)), transform));
    
    return polygon;
}

#pragma mark - Initialization and deallocation

- (id)initWithRouter:(LARouter*)router rectangle:(CGRect)rect angle:(CGFloat)angle
{
    self = [super init];
    if (self) {
        _router = [router retain];
        
        if (StandarizeAngle(angle) != 0) {
            Avoid::Polygon polygon = MakePolygon(rect, angle);
            _shapeRef = new Avoid::ShapeRef((Avoid::Router*)[router routerRef], polygon);
        }
        else {
            Avoid::Rectangle rectangle(Avoid::Point(CGRectGetMinX(rect), CGRectGetMinY(rect)), Avoid::Point(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
            _shapeRef = new Avoid::ShapeRef((Avoid::Router*)[router routerRef], rectangle);
        }
        
        _hasCreatedConnectionPin[LAShapeConnectionPinTop] = false;
        _hasCreatedConnectionPin[LAShapeConnectionPinRight] = false;
        _hasCreatedConnectionPin[LAShapeConnectionPinBottom] = false;
        _hasCreatedConnectionPin[LAShapeConnectionPinLeft] = false;
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    ((Avoid::Router*)[_router routerRef])->deleteShape((Avoid::ShapeRef*)_shapeRef);
    [_router release];
    [super dealloc];
}

#pragma mark - Operations

- (void)moveToRectangle:(CGRect)rect angle:(CGFloat)angle
{
    if (StandarizeAngle(angle) != 0) {
        Avoid::Polygon polygon = MakePolygon(rect, angle);
        ((Avoid::Router*)[_router routerRef])->moveShape((Avoid::ShapeRef*)_shapeRef, polygon);
    }
    else {
        Avoid::Rectangle rectangle(Avoid::Point(CGRectGetMinX(rect), CGRectGetMinY(rect)), Avoid::Point(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
        ((Avoid::Router*)[_router routerRef])->moveShape((Avoid::ShapeRef*)_shapeRef, rectangle);
    }
}

- (unsigned int)connectionPinIdentifier:(LAShapeConnectionPin)connectionPin
{
    if (!_hasCreatedConnectionPin[connectionPin]) {
        // Calculate the offsets.
        double xPortionOffset;
        double yPortionOffset;
        double insideOffset;
        if (_delegate) {
            [_delegate shape:self needsXPortionOffset:&xPortionOffset yPortionOffset:&yPortionOffset andInsideOffset:&insideOffset forConnectionPin:connectionPin];
        }
        else {
            switch (connectionPin) {
                case LAShapeConnectionPinTop:
                    xPortionOffset = Avoid::ATTACH_POS_CENTRE;
                    yPortionOffset = Avoid::ATTACH_POS_TOP;
                    break;
                case LAShapeConnectionPinRight:
                    xPortionOffset = Avoid::ATTACH_POS_RIGHT;
                    yPortionOffset = Avoid::ATTACH_POS_CENTRE;
                    break;
                case LAShapeConnectionPinLeft:
                    xPortionOffset = Avoid::ATTACH_POS_LEFT;
                    yPortionOffset = Avoid::ATTACH_POS_CENTRE;
                    break;
                default:
                    // Assumes bottom.
                    xPortionOffset = Avoid::ATTACH_POS_CENTRE;
                    yPortionOffset = Avoid::ATTACH_POS_BOTTOM;
                    break;
            }
            insideOffset = 0;
        }
        
        // Calculate the connection direction.
        Avoid::ConnDirFlag visDirs = Avoid::ConnDirNone; // TODO: verify if we need to change this.
        
        // Create the connection pin.
        Avoid::ShapeConnectionPin *pinRef = new Avoid::ShapeConnectionPin((Avoid::ShapeRef*)_shapeRef, connectionPin, xPortionOffset, yPortionOffset, insideOffset, visDirs);
        pinRef->setExclusive(false);
    }
    return connectionPin;
}

@end
