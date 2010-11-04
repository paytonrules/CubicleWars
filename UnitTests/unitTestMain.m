#import <UIKit/UIKit.h>
#import "CubicleWars.h"
#import "GameController.h"
#import "OCSpecFail.h"
#import "OCSpecDescription.h"
#import "OCSpecExample.h"

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
  description.outputter = [NSFileHandle fileHandleWithNullDevice];
  
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
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager createFileAtPath:outputterPath contents:nil attributes:nil];
  NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];
  
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = outputter;
  
  int outputLine = __LINE__ + 1;
  void (^test) (void) = [^(void) {FAIL(@"Fail");} copy];
  NSArray *tests = [NSArray arrayWithObject:test];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  Block_release(test);
  
  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];
  
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

void testDefaultOutputterIsStandardError()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  if (description.outputter != [NSFileHandle fileHandleWithStandardError])
    FAIL(@"Should have had standard error.  Didn't");
}

void testDescribeWorksWithMultipleTests()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = [NSFileHandle fileHandleWithNullDevice];
  
  void (^testOne) (void) = [^(void) {FAIL(@"Fail One");} copy];
  void (^testTwo) (void) = [^(void) {FAIL(@"Fail Two");} copy];
  
  NSArray *tests = [NSArray arrayWithObjects:testOne, testTwo, nil];
  
  [testOne release];
  [testTwo release];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  if (description.errors != 2)
  {
    FAIL(@"Should have had two errors, didn't");
  }
}

void testDescribeWorksWithMutlipleSuccesses()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = [NSFileHandle fileHandleWithNullDevice];
  
  void (^testOne) (void) = [^(void) {} copy];
  void (^testTwo) (void) = [^(void) {} copy];
  
  NSArray *tests = [NSArray arrayWithObjects:testOne, testTwo, nil];
  
  [testOne release];
  [testTwo release];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  if (description.successes != 2)
  {
    FAIL(@"Should have had two successes, didn't");
  }
}

// Clean up these tests below!
   // Stop calling functions - stop loading arrays.  Do it the way you want to.  Don't forget these blocks need to be copied
   // See if you can move that out of main
   // Probably get the describe into the actual error message
   // Kill block duplication - maybe with an it.
   // Outputter needs to be a class member.
  

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
    FAIL(@"Controller needed to be updated and wasn't");
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
  
  void (^testGameCallsUpdateOnControllerBlock) (void) = [^(void) {testGameCallsUpdateOnController();} copy];
  void (^testGameCallsUpdateOnControllerWithDeltaBlock) (void) = [^(void) {testGameCallsUpdateOnControllerWithDelta();} copy];
  
  OCSpecDescription *gameDescription = [[[OCSpecDescription alloc] init] autorelease];
  NSArray *examplesForGame = [NSArray arrayWithObjects:testGameCallsUpdateOnControllerBlock, testGameCallsUpdateOnControllerWithDeltaBlock, nil];
  [gameDescription describe:@"Game Controller" onArrayOfExamples:examplesForGame];

  [testGameCallsUpdateOnControllerBlock release];
  [testGameCallsUpdateOnControllerWithDeltaBlock release];
  
  errors = gameDescription.errors;
  successes = gameDescription.successes;
  
  void (^testDescribeWithNoErrorsBlock) (void) = [[^(void) {testDescribeWithNoErrors();} copy] autorelease];
  void (^testDescribeWithOneErrorBlock) (void) = [[^(void) {testDescribeWithOneError();} copy] autorelease];
  void (^testFailBlock) (void) = [[^(void) {testFail();} copy] autorelease];
  void (^testDescribeWithErrorWritesExceptionToOutputterBlock) (void) = [[^(void) {testDescribeWithErrorWritesExceptionToOutputter();} copy] autorelease];
  void (^testDefaultOutputterIsStandardErrorBlock) (void) = [[^(void) {testDefaultOutputterIsStandardError();} copy ] autorelease];
  void (^testDescribeWorksWithMultipleTestsBlock) (void) = [[^(void) {testDescribeWorksWithMultipleTests(); } copy ] autorelease ];
  
  OCSpecDescription *testsDescription = [[[OCSpecDescription alloc] init] autorelease];
  NSArray *examplesForTests = [NSArray arrayWithObjects:testDescribeWithNoErrorsBlock, testDescribeWithOneErrorBlock, testFailBlock, testDescribeWithErrorWritesExceptionToOutputterBlock, testDefaultOutputterIsStandardErrorBlock, testDescribeWorksWithMultipleTestsBlock, nil];
  [testsDescription describe:@"Unit Tests" onArrayOfExamples:examplesForTests];
  
  errors += testsDescription.errors;
  successes += testsDescription.successes;
  
  OCSpecExample *example = IT(@"Should Fail One Test", ^{
    FAIL(@"You have failed");
  });
  
  [example run];
  
  if (example.failed != YES) 
  {
    FAIL(@"That example should have failed.  It didn't");
    errors++;
  } 
    

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