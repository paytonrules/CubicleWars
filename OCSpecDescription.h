#import <Foundation/Foundation.h>

@interface OCSpecDescription : NSObject 
{
  NSInteger errors;
}

@property(assign) NSInteger errors;
-(void) describe:(NSString *)name onExamples:(id) test, ...;

@end
