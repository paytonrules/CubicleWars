#import <UIKit/UIKit.h>
#import "CubicleWars.h"
#import "GameController.h"

@interface MockGameController : NSObject<GameController>
{
  BOOL updated;
}

@property(readonly) BOOL updated;
-(void) update;
@end

@implementation MockGameController
@synthesize updated;

-(void) update
{
  updated = YES;
}

@end

@interface TestClass : NSObject
{
}

@end

@implementation TestClass

-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  CubicleWars *game = [[CubicleWars alloc] init];
  MockGameController *controller = [[[MockGameController alloc] init] autorelease];
  game.controller = controller;
  
  [game loop];
  
  if (controller.updated != YES)
  {
    fprintf(stderr, "%s:%ld: error: -[%s %s] : %s\n",
            "filename", //[filename UTF8String],
            100L, //(long)[lineNumber integerValue],
            "classnamee", //[className UTF8String],
            "name", // [name UTF8String],
            "reason"); // [[exception reason] UTF8String]);
    fflush(stderr);
  }
  [game release];
  
  // Display an alert
  
  
  // You should terminate with the number of failures
  [app performSelector:@selector(_terminateWithStatus:) withObject:(id) 0];
}

@end



int main(int argc, char *argv[]) 
{  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  UIApplicationMain(argc, argv, nil, @"TestClass");
    
  [pool release];
  return 0;
}