#import "OCSpecDescription.h"

@implementation OCSpecDescription

@synthesize errors;

-(void) describe:(NSString *)name onExamples:(id) test, ...
{
  id currentTest;
  va_list testList;
  
  if (test)
  {
    va_start(testList, test);
    while ( currentTest = va_arg(testList, id) )
    {
      @try 
      {
        ((void (^)(void)) test)();
      }
      @catch (NSException * e) 
      {
        self.errors++;
      }
    }
    va_end(testList);
  }
  
  /*
  @try 
  {
    
    //successes++;
  }
  @catch (NSException * e) 
  {
    fprintf(stderr, "%s:%ld: error: -[%s %s] : %s\n",
            [[[e userInfo] objectForKey:@"file"] UTF8String],
            [[[e userInfo] objectForKey:@"line"] longValue],
            [[[e userInfo] objectForKey:@"className"] UTF8String],
            [[[e userInfo] objectForKey:@"name"] UTF8String],
            [[e reason] UTF8String]);  
    //  errors++;
  }*/
}

@end
