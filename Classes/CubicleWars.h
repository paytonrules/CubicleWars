
#import <Foundation/Foundation.h>
#import "GameController.h"

@interface CubicleWars : NSObject 
{
  id<GameController>  controller;
}

@property(nonatomic, retain) id<GameController> controller;

-(void) loop;

@end
