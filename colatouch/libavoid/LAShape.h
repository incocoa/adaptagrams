//
//  LAShape.h
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAObstacle.h"


@class LARouter;
@class LAShape;


typedef enum {
    LAShapeConnectionPinTop = 0,
    LAShapeConnectionPinRight = 1,
    LAShapeConnectionPinBottom = 2,
    LAShapeConnectionPinLeft = 3,
    
    LAShapeConnectionPinMax = LAShapeConnectionPinLeft,
} LAShapeConnectionPin;


@protocol LAShapeDelegate <NSObject>

- (void)shape:(LAShape*)shape needsXPortionOffset:(double*)outXPortionOffset yPortionOffset:(double*)outYPortionOffset andInsideOffset:(double*)outInsideOffset forConnectionPin:(LAShapeConnectionPin)connectionPin;

@end


@interface LAShape : NSObject<LAObstacle> {
@private
    LARouter *_router;
    void *_shapeRef;

    bool _hasCreatedConnectionPin[LAShapeConnectionPinMax + 1];
    id<LAShapeDelegate> _delegate;
}

@property (nonatomic, readonly) void *shapeRef;
@property (nonatomic, assign) id<LAShapeDelegate> delegate;

- (id)initWithRouter:(LARouter*)router rectangle:(CGRect)rect angle:(CGFloat)angle;

- (void)moveToRectangle:(CGRect)rect angle:(CGFloat)angle;
- (unsigned int)connectionPinIdentifier:(LAShapeConnectionPin)connectionPin;

@end
