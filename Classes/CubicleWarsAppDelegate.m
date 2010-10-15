//
//  CubicleWarsAppDelegate.m
//  CubicleWars
//
//  Created by Eric Smith on 10/15/10.
//  Copyright 8th Light 2010. All rights reserved.
//

#import "CubicleWarsAppDelegate.h"
#import "EAGLView.h"

@implementation CubicleWarsAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions   
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];

    [super dealloc];
}

@end
