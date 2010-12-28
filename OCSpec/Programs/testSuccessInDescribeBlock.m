#import "OCSpec.h"
#import "OCSpecExample.h"

DESCRIBE(@"Test Description",
  IT(@"Succeeds", ^{
  })
);

@interface TestClass : NSObject
-(void) applicationDidFinishLaunching:(UIApplication *)app;
@end

@implementation TestClass

-(void) applicationDidFinishLaunching:(UIApplication *)app
{
  OCSpecExample *example = [[OCSpecExample alloc] initWithBlock: ^{
    OCSpecDescriptionRunner *runner = [[[OCSpecDescriptionRunner alloc] init] autorelease];
    
    [runner runAllDescriptions];
    
    if (runner.successes != 1)
    {
      FAIL(@"Did not run the successful test");
    }     
  }];
  
  [example run];
  
  [app performSelector:@selector(_terminateWithStatus:) withObject:(id) (example.failed ? 1 : 0)];
}
@end

// This one off program exists specifically to test that the DESCRIBE macro generates 
// the classes necessary for the auto runners.  Putting them in with the other tests
// causes them to interfere with those tests, so I've got this tiny program.
// Theoretically redundant since the Macros are implicitly tested by being used in the tests.
int main(int argc, char *argv[]) 
{  
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  UIApplicationMain(argc, argv, nil, @"TestClass");

  [pool release];
  return 0;
}
