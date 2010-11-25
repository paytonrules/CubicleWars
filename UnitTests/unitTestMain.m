#include <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "CubicleWars.h"
#import "GameController.h"
#import "OCSpecFail.h"
#import "OCSpecDescription.h"
#import "OCSpecExample.h"
#import "MockExample.h"
#import "DescriptionRunner.h"
#import "OCSpecDescriptionRunner.h"

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

static BOOL ranDescription = NO;
@interface TestDescriptionRunner : NSObject<DescriptionRunner>
{
}

@end

@implementation TestDescriptionRunner

+(void) run
{
  ranDescription = YES;
}

+(NSNumber *) getSuccesses
{
  NSLog(@"Entered the TestDescriptionRunner getSuccesses");
  return [NSNumber numberWithInt:0];
}

+(void) setSuccess:(int) number
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

  NSString *errorFormat = [NSString stringWithFormat:@"%s:%ld: error: %@\n",
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
//
NSString *OutputterPath()
{
  return [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
}

NSFileHandle *GetTemporaryFileHandle()
{
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager createFileAtPath:OutputterPath() contents:nil attributes:nil];
  return [NSFileHandle fileHandleForWritingAtPath:OutputterPath()]; 
}

NSString *ReadTemporaryFile()
{
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];
  return [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                encoding:NSUTF8StringEncoding] autorelease];
}

void DeleteTemporaryFile()
{
  NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  [fileManager removeItemAtPath:outputterPath error:NULL];
}

void testDescribeWithErrorWritesExceptionToOutputter()
{
  NSFileHandle *outputter = GetTemporaryFileHandle(); 
  
  OCSpecDescription *description = [[[OCSpecDescription alloc] init] autorelease];
  description.outputter = outputter;
  
  OCSpecExample *example = [[[OCSpecExample alloc] initWithBlock:^{ FAIL(@"FAIL"); }] autorelease];
  NSArray *tests = [NSArray arrayWithObject: example];
  
  [description describe:@"It Should Do Something" onArrayOfExamples: tests];

  NSString *outputException = ReadTemporaryFile();  
  if (outputException.length == 0)
  {
    FAIL(@"An exception should have been written to the outputter - but wasn't.");
  }

  DeleteTemporaryFile();
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

static BOOL ranMeToo;
static void run(id self, SEL _cmd)
{
  ranMeToo = YES;
}

static int classLevelSuccesses = 0;
static void setSuccesses(id self, SEL _cmd, int numSuccesses)
{
  NSLog(@"Setting successes to %d because it is currently %d", numSuccesses, classLevelSuccesses);
  classLevelSuccesses = numSuccesses;
}

static NSNumber *getSuccesses(id self, SEL _cmd)
{
  return [NSNumber numberWithInt: classLevelSuccesses];
}

Class CreateExampleStaticDescription(const char *name)
{
  Class myExampleStaticDescription = objc_allocateClassPair([NSObject class], name, 0);

  Method indexOfObject = class_getClassMethod([TestDescriptionRunner class], @selector(run));
  const char *types = method_getTypeEncoding(indexOfObject);
  objc_registerClassPair(myExampleStaticDescription);

  Class metaClass = objc_getMetaClass(name);
  class_addProtocol(myExampleStaticDescription, @protocol(DescriptionRunner));
  class_addMethod(metaClass, @selector(run), (IMP) run, types);
  class_addMethod(metaClass, @selector(getSuccesses), (IMP) getSuccesses, types);
  indexOfObject = class_getClassMethod([TestDescriptionRunner class], @selector(setSuccesses:));
  types = method_getTypeEncoding(indexOfObject);
  class_addMethod(metaClass, @selector(setSuccesses:), (IMP) setSuccesses, types);

  return myExampleStaticDescription;
}

  
@implementation TestClass


// Clean up these tests below!
// See if you can move that out of main (Test Runner)
// Use those strings in the examples and in the describe
// Test the counting.
// Memory!
// setup/teardown
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
  
  OCSpecDescription *runnerDescription = DESCRIBE(@"OCSpecDescriptionRunner",
    IT(@"Should call the run method on the TestDescriptionRunner defined above", ^{
      OCSpecDescriptionRunner *runner = [[[OCSpecDescriptionRunner alloc] init] autorelease];
    
      [runner runAllDescriptions];
      
      if (ranDescription == NO)
        FAIL(@"Should have ran the static description, didn't");
    }),
    
    IT(@"Should call the run method on all classes that conform to the description protocol", ^{      
      OCSpecDescriptionRunner *runner = [[[OCSpecDescriptionRunner alloc] init] autorelease];
      Class myExampleStaticDescription = CreateExampleStaticDescription("myExampleStaticDescription");
   
      [runner runAllDescriptions];
    
      if (ranMeToo == NO) 
        FAIL(@"Should have run the dynamically created class, didn't cause it's a jerk");

      objc_disposeClassPair(myExampleStaticDescription);
    }),

    IT(@"Should write the final results to its outputter", ^{
      OCSpecDescriptionRunner *runner = [[[OCSpecDescriptionRunner alloc] init] autorelease];

      NSString *outputterPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
      NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
      [fileManager createFileAtPath:outputterPath contents:nil attributes:nil];
      NSFileHandle *outputter = [NSFileHandle fileHandleForWritingAtPath:outputterPath];
      runner.outputter = outputter;

      [runner runAllDescriptions];

      NSFileHandle *inputFile = [NSFileHandle fileHandleForReadingAtPath:outputterPath];

      NSString *outputException = [[[NSString alloc] initWithData:[inputFile readDataToEndOfFile] 
                                                         encoding:NSUTF8StringEncoding] autorelease];

      if ([outputException compare:@"Tests ran with 0 passing tests and 0 failing tests\n"] != 0)
      {
        FAIL(@"Final test message was not written to the outputter");
      }

      [fileManager removeItemAtPath:outputterPath error:NULL];
    }),

    IT(@"Should total up the successes in the outputters message", ^{
      Class myExampleStaticDescription = CreateExampleStaticDescription("myExampleStaticDescription");
      [myExampleStaticDescription setSuccesses:3];

      OCSpecDescriptionRunner *runner = [[[OCSpecDescriptionRunner alloc] init] autorelease];
      runner.outputter = GetTemporaryFileHandle();

      [runner runAllDescriptions];
      
      NSString *outputException = ReadTemporaryFile();  

      if ([outputException compare:@"Tests ran with 3 passing tests and 0 failing tests\n"] != 0)
      {
        NSLog(@"output message is %@", outputException);
        FAIL(@"The wrong number of passing tests was written");
      }

      DeleteTemporaryFile();
    })


    // Need to pass outputter through
    // Total up results
    // These Describes need to create this class.

  );
  
  gameDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [gameDescription describe];
  
  testDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [testDescription describe];
  
  itDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [itDescription describe];
  
  runnerDescription.outputter = [NSFileHandle fileHandleWithStandardError];
  [runnerDescription describe];
  
  errors = gameDescription.errors + testDescription.errors + itDescription.errors + runnerDescription.errors;
  successes = gameDescription.successes + testDescription.successes + itDescription.successes + runnerDescription.successes;

  NSLog(@"Tests ran with %d passing tests and %d failing tests", successes, errors);
  
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
