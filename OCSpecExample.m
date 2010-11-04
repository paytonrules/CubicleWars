#import "OCSpecExample.h"

@implementation OCSpecExample

@synthesize failed;

-(id) init
{
  if (self = [super init]) 
  {
    failed = YES;
  }
  return self;
}

-(void) run
{
}

@end