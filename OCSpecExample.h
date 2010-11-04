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
  BOOL  failed;
}

@property(readonly) BOOL failed;
-(void) run;

@end


#define IT(description, example) [[OCSpecExample alloc] init];

