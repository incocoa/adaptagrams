//
//  LAJunction.h
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAObstacle.h"


@class LARouter;


@interface LAJunction : NSObject<LAObstacle> {
@private
    LARouter *_router;
    void *_junctionRef;
}

@property (nonatomic, readonly) void *junctionRef;

- (id)initWithRouter:(LARouter*)router rectangle:(CGRect)rect angle:(CGFloat)angle;

- (void)moveToRectangle:(CGRect)rect angle:(CGFloat)angle;

@end
