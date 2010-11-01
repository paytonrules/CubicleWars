#import "OCSpecDescription.h"

@implementation OCSpecDescription

@synthesize errors, outputter;

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
      NSLog(@"Writing the output file");
      NSLog(@"%@ is the outputter", outputter);
      
      [outputter writeData:[errorString dataUsingEncoding:NSUTF8StringEncoding]];
      
      NSLog(@"Wrote it - cause I'm a bad ass");
      self.errors++;
    }
  }];
}

@end
