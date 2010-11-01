#import "OCSpecDescription.h"

@implementation OCSpecDescription

@synthesize errors, outputter;

-(id) init
{
  if (self = [super init]) 
  {
    self.outputter = [NSFileHandle fileHandleWithStandardError];
  }
  return self;
}

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
      NSString *errorString = [NSString stringWithFormat:@"%s:%ld: error: %@",
                               [[[e userInfo] objectForKey:@"file"] UTF8String],
                               [[[e userInfo] objectForKey:@"line"] longValue],
                               [e reason]];

      [outputter writeData:[errorString dataUsingEncoding:NSUTF8StringEncoding]];

      self.errors++;
    }
  }];
}

@end
