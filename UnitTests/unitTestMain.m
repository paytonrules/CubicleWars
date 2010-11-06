#import <UIKit/UIKit.h>
#import "CubicleWars.h"
#import "GameController.h"
#import "OCSpecFail.h"
#import "OCSpecDescription.h"
#import "OCSpecExample.h"
#import "MockExample.h"

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
  
  MockExample *example = [MockExample exampleThatFailed];
  NSArray *examples = [NSArray arrayWithObjects:example, nil];
  [description describe:@"It Should Do Something" onArrayOfExamples: examples];
  
  if (description.errors != 1)
  {
    FAIL(@"Should have had 1 error, did not");
  }
}

void testExampleWritesExceptionToOutputter()
{
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager createFileAtPath:outputterPath contents:nil attributes:nil];
  NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];

  OCSpecExample *example = [[[OCSpecExample alloc] initWithBlock:^{ FAIL(@"FAIL"); }] autorelease];
  example.outputter = outputter;
  
  [example run];
  
  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];
  NSString *outputException = [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                                     encoding:NSUTF8StringEncoding] autorelease];
  if (outputException.length == 0)
  {
    FAIL(@"An exception should have been written to the outputter - but wasn't.");
  }
  
  [fileManager removeItemAtPath:outputterPath error:NULL];
}

void testExceptionFormat()
{
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager createFileAtPath:outputterPath contents:nil attributes:nil];
  NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];
  
  int outputLine = __LINE__ + 1;
  OCSpecExample *example = [[[OCSpecExample alloc] initWithBlock:^{ FAIL(@"FAIL"); }] autorelease];
  example.outputter = outputter;
  
  [example run];

  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];

  NSString *outputException = [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                                     encoding:NSUTF8StringEncoding] autorelease];

  NSString *errorFormat = [NSString stringWithFormat:@"%s:%ld: error: %@",
           __FILE__,
           outputLine,
           @"FAIL"];

  // This is a string match assertion :)
  if ([outputException compare:errorFormat] != 0)
  {
    NSString *failMessage = [NSString stringWithFormat:@"%@ expected, received %@", errorFormat, outputException];
    FAIL(failMessage);
  }
  
  [fileManager removeItemAtPath:outputterPath error:NULL];
}

// You are gonna need a setup/teardown sooner rather than later
// before/after

void testDescribeWithErrorWritesExceptionToOutputter()
{
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager createFileAtPath:outputterPath contents:nil attributes:nil];
  NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];
  
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = outputter;
  
  OCSpecExample *example = [[[OCSpecExample alloc] initWithBlock:^{ FAIL(@"FAIL"); }] autorelease];
  NSArray *tests = [NSArray arrayWithObject: example];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];
  
  NSString *outputException = [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                                encoding:NSUTF8StringEncoding] autorelease];
  
  if (outputException.length == 0)
  {
    FAIL(@"An exception should have been written to the outputter - but wasn't.");
  }
  
  [fileManager removeItemAtPath:outputterPath error:NULL];
}

void testDefaultOutputterIsStandardError()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  
  if (description.outputter != [NSFileHandle fileHandleWithStandardError])
  {
    FAIL(@"Should have had standard error.  Didn't");
  }
}

void testDescribeWorksWithMultipleTests()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = [NSFileHandle fileHandleWithNullDevice];
  
  OCSpecExample *exampleOne = [[[OCSpecExample alloc] initWithBlock: ^{ FAIL(@"Fail One"); }] autorelease];
  OCSpecExample *exampleTwo = [[[OCSpecExample alloc] initWithBlock: ^{ FAIL(@"Fail Two"); }] autorelease];
  
  NSArray *tests = [NSArray arrayWithObjects:exampleOne, exampleTwo, nil];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  if (description.errors != 2)
  {
    FAIL(@"Should have had two errors, didn't");
  }
}

void testDescribeWorksWithMultipleSuccesses()
{
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = [NSFileHandle fileHandleWithNullDevice];
  
  OCSpecExample *exampleOne = [[[OCSpecExample alloc] initWithBlock: ^{ }] autorelease];
  OCSpecExample *exampleTwo = [[[OCSpecExample alloc] initWithBlock: ^{ }] autorelease];
  
  NSArray *tests = [NSArray arrayWithObjects:exampleOne, exampleTwo, nil];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];
  
  if (description.successes != 2)
  {
    FAIL(@"Should have had two successes, didn't");
  }
}
  

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

void testDescribeMacro()
{
  OCSpecDescription *description = DESCRIBE(@"A thing", 
                                            IT(@"Should Succeed", ^{}),
                                            IT(@"Should Fail", ^{ FAIL(@"Monkey"); } ));
  
  [description describe];
  
  if (description.errors != 1)
  {
    FAIL(@"Should have had just one error");
  }
}
  
@implementation TestClass


// Clean up these tests below!
// See if you can move that out of main
// Probably get the describe into the actual error message
// Use those strings in the examples and in the describe
-(void) applicationDidFinishLaunching:(UIApplication *) app
{
  int errors = 0;
  int successes = 0;
  
  OCSpecDescription *gameDescription = DESCRIBE(@"Description that is not used - Game controller Tests",
    
    IT(@"Calls Update on the Game Controller", ^{
      testGameCallsUpdateOnController();
    }),
    
    IT(@"Calls Update on the Game Controller with delta", ^{
      testGameCallsUpdateOnControllerWithDelta();
    })
  );
  
  OCSpecDescription *testDescription = DESCRIBE(@"Unit tests for my test 'framework'", 
    
    IT(@"Has an example without errors", ^{
      testDescribeWithNoErrors();
    }),
    
    IT(@"Has an example with one error", ^{
      testDescribeWithOneError();
    }),
                                                
    IT(@"Has a faliure assertion", ^{
      testFail();
    }),

    IT(@"Describe write the exemption to the outputter", ^{
      testDescribeWithErrorWritesExceptionToOutputter();
    }),

    IT(@"Describes default ouputter is standard error", ^{
      testDefaultOutputterIsStandardError();
    }),

    IT(@"Describe multiple examples", ^{
      testDescribeWorksWithMultipleTests();
    }),
    
    IT(@"Describes multipole successes", ^{
      testDescribeWorksWithMultipleSuccesses();
    }),

    IT(@"Examples write their exceptions to the outputter", ^{
      testExampleWritesExceptionToOutputter();
    }),

    IT(@"Examples write their output in a XCode friendly format", ^{
      testExceptionFormat();
    }),

    IT(@"Describe can use a macro", ^{
      testDescribeMacro();
    })
  );
  
  OCSpecDescription *itDescription = DESCRIBE(@"OCSpecExample", 
    IT(@"Should Fail One Test", ^{
      BOOL caughtFailure = NO;
      @try 
      {
        FAIL(@"You have failed");
      }
      @catch (NSException * e)
      {
        caughtFailure = YES;
      }
      if (caughtFailure != YES) 
      {
        FAIL(@"This should have raised a failure");
      }
    }),
                                              
    IT(@"Should Pass An empty Test", ^{})
  );
  
  gameDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [gameDescription describe];
  
  itDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [itDescription describe];

  testDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [testDescription describe];
  
  errors = gameDescription.errors + testDescription.errors + itDescription.errors;
  successes = gameDescription.successes + testDescription.successes + itDescription.successes;

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
