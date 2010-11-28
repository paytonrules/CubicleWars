#import <Foundation/Foundation.h>

@interface OCSpecDescriptionRunner : NSObject 
{
  Class         *classes;
  NSInteger     classCount;
  NSFileHandle  *outputter;
  int           successes;
  int           failures;
}

@property(nonatomic, retain) NSFileHandle *outputter;
-(void) runAllDescriptions;
@end
