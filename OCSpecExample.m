#import "OCSpecExample.h"

@implementation OCSpecExample

@synthesize failed;

-(id) init
{
  if (self = [super init]) 
  {
    failed = YES;
    outputter = [NSFileHandle fileHandleWithStandardError];
  }
  return self;
}

-(id) initWithBlock:(void (^)(void))example
{
  if (self = [super init])
  {
    failed = NO;
    itsExample = [example copy];
  }
  return self;
}

-(void) run
{
  @try
  {
    void (^test) (void) = itsExample;
    test();
  }
  @catch (NSException * e)
  {
    NSString *errorString = [NSString stringWithFormat:@"%s:%ld: error: %@",
                             [[[e userInfo] objectForKey:@"file"] UTF8String],
                             [[[e userInfo] objectForKey:@"line"] longValue],
                             [e reason]];
    
    [outputter writeData:[errorString dataUsingEncoding:NSUTF8StringEncoding]];
    
    failed = YES;
  }
}

// Dealloc the block!

@end