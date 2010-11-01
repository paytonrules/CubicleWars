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

void testDescribeWithNoErrors()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: [[[NSArray alloc] init] autorelease]];
  
  if (description.errors != 0) {
    FAIL(@"Should have had 0 errors.  Did not");
  }
}

void testDescribeWithOneError()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  void (^test) (void) = [^(void) {FAIL(@"Fail");} copy];
  NSArray *tests = [NSArray arrayWithObject:test];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  Block_release(test);
  
  if (description.errors != 1)
  {
    FAIL(@"Should have had 1 error, did not");
  }
}

void testDescribeWithErrorWritesExceptionToOutputter()
{
  NSLog(@"Running the testDescribeWithErrorWritesExceptionToOutputter test");
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  
  if ([fileManager createFileAtPath:outputterPath contents:nil attributes:nil] == NO)
    FAIL(@"Could not create tempfile");
 
  NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];
  
  if (outputter == nil) 
  {
    FAIL(@"Could not create file outputter");
  }
  
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = outputter;
  
  int outputLine = __LINE__ + 1;
  void (^test) (void) = [^(void) {FAIL(@"Fail");} copy];
  NSArray *tests = [NSArray arrayWithObject:test];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  Block_release(test);
  
  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];
  
  if (inputFile == nil) 
  {
    FAIL(@"Could not create input file handle");
  }
  
  NSString *outputException = [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                                encoding:NSUTF8StringEncoding] autorelease];
  
  NSString *errorFormat = [NSString stringWithFormat:@"%s:%ld: error: %@",
                           __FILE__,
                           outputLine,
                           @"Fail"];
  
  if ([outputException compare:errorFormat] != 0)
  {
    NSString *failMessage = [NSString stringWithFormat:@"%@ expected, received %@", errorFormat, outputException];
    FAIL(failMessage);
  }
}

// Default outputter is standarderrr
// Test works with multiple tests (and errors/successes)
// Clean up these tests below!
   // Make them use describes
   // Probably get the describe into the actual error message
   // Kill block duplication - maybe with an it.
  

void testGameCallsUpdateOnControllerWithDelta()
{
 // FAIL(@"Controller expected to be updated with delta and wasn't");
}

void testGameCallsUpdateOnController()
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

void testFail() 
{
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


@implementation TestClass



-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  int errors = 0;
  int successes = 0;
  
  @try 
  {
    testGameCallsUpdateOnController();
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

  @try 
  {
    testGameCallsUpdateOnControllerWithDelta();
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
  
  @try 
  {
    testDescribeWithNoErrors();
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
  
  @try 
  {
    testDescribeWithOneError();
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
  
  @try 
  {
    testFail();
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
  
  @try 
  {
    testDescribeWithErrorWritesExceptionToOutputter();
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