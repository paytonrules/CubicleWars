#import <Foundation/Foundation.h>

@interface OCSpecDescription : NSObject 
{
  NSInteger     errors;
  NSInteger     successes;
  NSFileHandle  *outputter;
}

@property(assign) NSInteger errors;
@property(assign) NSInteger successes;
@property(nonatomic, retain) NSFileHandle *outputter;
-(void) describe:(NSString *)name onArrayOfExamples:(NSArray *) examples;

@end
