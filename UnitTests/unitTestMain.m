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

-(void) testGameCallsUpdateOnControllerWithDelta
{ 
  NSException *exception = [NSException exceptionWithName:@"Test Failed"
                                                   reason:@"Controller expected to be updated with delta and wasn't"
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys: @"TestClass", @"className",
                                                                                                      @"GameCallsUpdateOnController", @"name", 
                                                                                                      [NSNumber numberWithInt:__LINE__], @"line", 
                                                                                                      [NSString stringWithUTF8String:__FILE__], @"file", nil]];
    
  [exception raise];
}

-(void) testGameCallsUpdateOnController
{
  CubicleWars *game = [[CubicleWars alloc] init];
  MockGameController *controller = [[[MockGameController alloc] init] autorelease]; 
  game.controller = controller;
    
  [game loop];
    
  if (controller.updated != YES)
  {
    NSException *exception = [NSException exceptionWithName:@"Test Failed"
                                                     reason:@"Controller expected to be updated and wasn't"
                                                   userInfo:[NSDictionary dictionaryWithObjectsAndKeys: @"className", @"TestClass",
                                                                                                        @"name", @"GameCallsUpdateOnController", 
                                                                                                        @"line", [NSNumber numberWithInt:__LINE__], 
                                                                                                        @"file", [NSString stringWithUTF8String:__FILE__], nil]];
    [exception raise];
  }    

  [game release];
}

-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  int errors = 0;
  int successes = 0;
  
  @try 
  {
    [self testGameCallsUpdateOnController];
    successes++;
  }
  @catch (NSException * e) 
  {
    fprintf(stderr, "%s:%ld error: -[%s %s] : %s\n",
            [[[e userInfo] objectForKey:@"file"] UTF8String],
            [[[e userInfo] objectForKey:@"line"] longValue],
            [[[e userInfo] objectForKey:@"className"] UTF8String],
            [[[e userInfo] objectForKey:@"name"] UTF8String],
            [[e reason] UTF8String]);  
    errors++;
  }

  NSLog(@"About to try the failing test");
  @try 
  {
    [self testGameCallsUpdateOnControllerWithDelta];
    successes++;
  }
  @catch (NSException * e) 
  {
    fprintf(stderr, "%s:%ld: error: %s\n",
            [[[e userInfo] objectForKey:@"file"] UTF8String],
            [[[e userInfo] objectForKey:@"line"] longValue],
            [[[e userInfo] objectForKey:@"className"] UTF8String],
            [[[e userInfo] objectForKey:@"name"] UTF8String],
            [[e reason] UTF8String]);
    
    errors++;
  }
  
  fflush(stderr);
  
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