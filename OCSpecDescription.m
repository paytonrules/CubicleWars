#import "OCSpecDescription.h"

@implementation OCSpecDescription

@synthesize errors;

-(void) describe:(NSString *)name onArrayOfExamples:(NSArray *)examples
{
  [examples enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) 
  {
    @try 
    {
      void (^test) (void) = obj;
      test();
    }
    @catch (NSException * e) 
    {
      self.errors++;
    }
  }];
}

@end
