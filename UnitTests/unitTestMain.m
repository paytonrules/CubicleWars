#import <UIKit/UIKit.h>
#import "CubicleWars.h"
#import "GameController.h"
#import "OCSpecFail.h"
#import "OCSpecDescription.h"

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
  FAIL(@"Controller expected to be updated with delta and wasn't");
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

-(void) testDescribeWithNoErrors
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  [description describe:@"It Should Do Something" onExamples: ^(void) {}, nil];
  
  if (description.errors != 0) {
    FAIL(@"Should have had 0 errors.  Did not");
  }
}

-(void) testDescribeWithOneError
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  [description describe:@"It Should Do Something" onExamples: ^(void) {FAIL(@"Fail");}, nil];
  
  if (description.errors != 1)
  {
    FAIL(@"Should have had 1 error, did not");
  }
}

-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  __block int errors = 0;
  __block int successes = 0;
  
  void (^failTest) (void) = ^ {
    @try 
    {
      [OCSpecFail fail:@"Dude" atLine:1 inFile:@"file"];
      FAIL(@"Did not fail - in fail");
    }
    @catch (NSException *e) 
    {
      if ([e reason] != @"Dude")
        [e raise];
    }
  };
  
  void (^callUpdate) (void) = ^ {
    [self testGameCallsUpdateOnController];
  };
  
  void (^callUpdateWithDelta) (void) = ^ {
    [self testGameCallsUpdateOnControllerWithDelta];
  };
  
  void (^shouldDescribeNoErrors) (void) = ^ {
    [self testDescribeWithNoErrors];
  };
  
  void (^shouldDescribeWithOneError) (void) = ^ {
    [self testDescribeWithOneError];
  };
  
  void (^tests[]) (void) = {failTest, callUpdate, callUpdateWithDelta, shouldDescribeNoErrors, shouldDescribeWithOneError};

  for (int i = 0; i < 5; ++i) 
  {
    @try 
    {
      tests[i]();
      successes++;
    }
    @catch (NSException * e) 
    {
      fprintf(stderr, "%s:%ld: error: -[%s %s] : %s\n",
              [[[e userInfo] objectForKey:@"file"] UTF8String],
              [[[e userInfo] objectForKey:@"line"] longValue],
              [[[e userInfo] objectForKey:@"className"] UTF8String],
              [[[e userInfo] objectForKey:@"name"] UTF8String],
              [[e reason] UTF8String]);  
      errors++;
    }
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