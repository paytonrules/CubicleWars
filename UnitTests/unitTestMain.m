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

-(BOOL) testGameHasController
{
  CubicleWars *game = [[CubicleWars alloc] init];
  MockGameController *controller = [[[MockGameController alloc] init] autorelease];
  game.controller = controller;

  [game loop];

  if (controller.updated != YES)
  {
    fprintf(stderr, "%s:%ld: error: -[%s %s] : %s\n",
            __FILE__, //[filename UTF8String],
            (long) __LINE__, //(long)[lineNumber integerValue],
            "TestClass", //[className UTF8String],
            "applicationDidFinishLaunching", // [name UTF8String],
            "Your wrong"); // [[exception reason] UTF8String]);
    fflush(stderr);
    return NO;
  } 
  else 
  {
    return YES;
  }

  [game release];
}

-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  int errors = 0;
  int successes = 0;

  [self testGameHasController] ? successes++ : errors++;

  NSLog(@"Tests ran with %d passing tests and %d failing tests", successes, errors);
  
  // You should terminate with the number of failures
  [app performSelector:@selector(_terminateWithStatus:) withObject:(id) errors];
}

@end



int main(int argc, char *argv[]) 
{  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  UIApplicationMain(argc, argv, nil, @"TestClass");
    
  [pool release];
  return 0;
}