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
@class LAConnector;


@protocol LAConnectorDelegate <NSObject>

- (void)connectorHasNewRoute:(LAConnector*)connector;

@end


@interface LAConnector : NSObject {
@private
    LARouter *_router;
    void *_connectorRef;
    void *_routeCacheRef;
    
    id<LAConnectorDelegate> _delegate;
}

@property (nonatomic, readonly) void *connectorRef;
@property (nonatomic, assign) id<LAConnectorDelegate> delegate;

- (id)initWithRouter:(LARouter*)router
      sourceObstacle:(id<LAObstacle>)sourceObstacle
 sourceConnectionPin:(LAShapeConnectionPin)sourceConnectionPin
        destObstacle:(id<LAObstacle>)destObstacle
   destConnectionPin:(LAShapeConnectionPin)destConnectionPin;

- (void)setNeedsDisplay;
- (void)setEndpointsWithSourceObstacle:(id<LAObstacle>)sourceObstacle
                   sourceConnectionPin:(LAShapeConnectionPin)sourceConnectionPin
                          destObstacle:(id<LAObstacle>)destObstacle
                     destConnectionPin:(LAShapeConnectionPin)destConnectionPin;

- (size_t)size;
- (CGPoint)pointAtIndex:(size_t)index;

@end
