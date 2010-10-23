#import "CubicleWars.h"
#import "GameController.h"

@implementation CubicleWars

@synthesize controller;

-(void) loop
{
  [controller update];
}

@end
