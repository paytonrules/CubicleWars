#include <objc/runtime.h>
#import "OCSpecDescriptionRunner.h"
#import "DescriptionRunner.h"

@class TestDescriptionRunner;

@implementation OCSpecDescriptionRunner

@synthesize outputter;

-(BOOL) isDescriptionRunner:(Class) klass
{
  return class_respondsToSelector(klass, @selector(conformsToProtocol:)) && [klass conformsToProtocol:@protocol(DescriptionRunner)]; 
}

-(void) getListOfClassesInBundle
{
  classCount = objc_getClassList(NULL, 0);
  NSMutableData *classData = [NSMutableData dataWithLength:sizeof(Class) * classCount];
  
  // Allocate a list of classes of max size.  Could I make this an NSArray?
  classes = (Class*)[classData mutableBytes];

  // Get the real class list
  objc_getClassList(classes, classCount);
}

-(void) callRunOnEachStaticDescription
{
  for (int i = 0; i < classCount; ++i)
  {
    Class currClass = classes[i];
    
    // Check if it conforms our protocol
    if ([self isDescriptionRunner:currClass])
    {
      [currClass run];
    }
  }
}

-(void) reportResults
{
  [outputter writeData:[@"Tests ran with 0 passing tests and 0 failing tests\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) runAllDescriptions
{
  [self getListOfClassesInBundle];
  [self callRunOnEachStaticDescription];
  [self reportResults];
}

@end