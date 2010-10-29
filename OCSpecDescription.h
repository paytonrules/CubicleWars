#import <Foundation/Foundation.h>

@interface OCSpecDescription : NSObject 
{
  NSInteger errors;
}

@property(assign) NSInteger errors;
-(void) describe:(NSString *)name onArrayOfExamples:(NSArray *) examples;

@end
