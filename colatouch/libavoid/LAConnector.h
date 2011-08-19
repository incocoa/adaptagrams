//
//  LAConnector.h
//  libavoid
//
//  Created by Marcelo Boff on 11-08-19.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAShape.h"


@class LARouter;
@class LAConnectorRoute;


@interface LAConnector : NSObject {
@private
    LARouter *_router;
    void *_connectorRef;
    void *_routeCacheRef;
}

@property (nonatomic, readonly) void *connectorRef;

- (id)initWithRouter:(LARouter*)router
      sourceObstacle:(id<LAObstacle>)sourceObstacle
 sourceConnectionPin:(LAShapeConnectionPin)sourceConnectionPin
        destObstacle:(id<LAObstacle>)destObstacle
   destConnectionPin:(LAShapeConnectionPin)destConnectionPin;

- (void)setNeedsDisplay;
- (size_t)size;
- (CGPoint)pointAtIndex:(size_t)index;

@end
