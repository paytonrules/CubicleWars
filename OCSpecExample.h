//
//  OCSpecExample.h
//  CubicleWars
//
//  Created by Eric Smith on 11/4/10.
//  Copyright 2010 8th Light. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OCSpecExample : NSObject 
{
  BOOL          failed;
  id            itsExample;
  NSFileHandle  *outputter;
}

@property(readonly) BOOL failed;
-(void) run;
-(id) initWithBlock:(void (^)(void))example;

@end


#define IT(description, example) [[OCSpecExample alloc] initWithBlock:example];