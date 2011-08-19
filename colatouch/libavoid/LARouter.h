//
//  LARouter.h
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LARouter;
@class LAShape;
@class LAConnector;


typedef enum {
    LARouterWithPolyLineRouting,
    LARouterWithOrthogonalRouting,
} LARouterFlag;


@protocol LARouterDelegate <NSObject>

- (void)router:(LARouter*)router hasNewRouteForConnector:(LAConnector*)connector;

@end


@interface LARouter : NSObject {
@private
    void *routerRef;
    
    id<LARouterDelegate> _delegate;
}

@property (nonatomic, readonly) void *routerRef;
@property (nonatomic, assign) id<LARouterDelegate> delegate;

@property (nonatomic) BOOL useTransactions;
@property (nonatomic) BOOL nudgeOrthogonalSegmentsConnectedToShapes;
@property (nonatomic) double orthogonalNudgeDistance;

- (id)init;
- (id)initWithFlags:(LARouterFlag)flags;

- (void)processTransaction;

@end
