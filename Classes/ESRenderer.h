//
//  ESRenderer.h
//  CubicleWars
//
//  Created by Eric Smith on 10/15/10.
//  Copyright 8th Light 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

@protocol ESRenderer <NSObject>

- (void)render;
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
