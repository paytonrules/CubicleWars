#import <Foundation/Foundation.h>

@interface OCSpecDescription : NSObject 
{
  NSInteger     errors;
  NSFileHandle  *outputter;
}

@property(assign) NSInteger errors;
@property(nonatomic, retain) NSFileHandle *outputter;
-(void) describe:(NSString *)name onArrayOfExamples:(NSArray *) examples;

@end
