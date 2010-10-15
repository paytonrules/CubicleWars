//
//  CubicleWarsAppDelegate.h
//  CubicleWars
//
//  Created by Eric Smith on 10/15/10.
//  Copyright 8th Light 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLView;

@interface CubicleWarsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

