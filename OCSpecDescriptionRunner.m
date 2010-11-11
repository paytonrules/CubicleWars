#include <objc/runtime.h>
#import "OCSpecDescriptionRunner.h"
#import "DescriptionRunner.h"
@class TestDescriptionRunner;

@implementation OCSpecDescriptionRunner

// MEMORY!!!!!!!!!!!!!!!!!
-(void) runAllDescriptions
{
  // Get the number of classes
  int count = objc_getClassList(NULL, 0);
  NSMutableData *classData = [NSMutableData dataWithLength:sizeof(Class) * count];
  
  // Allocate a list of classes of max size.  Could I make this an NSArray?
  Class *classes = (Class*)[classData mutableBytes];
  
  // Get the real class list
  objc_getClassList(classes, count);
  
  // Loop through the count and call run on all of them
  for (int i = 0; i < count; ++i)
  {
    Class currClass = classes[i];
    
    // Check if it conforms our protocol
    if (class_respondsToSelector(currClass, @selector(conformsToProtocol:)) && [currClass conformsToProtocol:@protocol(DescriptionRunner)]) 
    {
      [currClass run];
    }
  }
}

@end
