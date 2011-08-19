//
//  LAObstacle.h
//  libavoid
//
//  Created by Marcelo Boff on 11-08-18.
//  Copyright (c) 2011 Marcelo Boff. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LAConnector;


@protocol LAObstacle <NSObject>

- (void)moveToRectangle:(CGRect)rect angle:(CGFloat)angle;

@end
