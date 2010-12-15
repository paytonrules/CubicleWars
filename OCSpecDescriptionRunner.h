#import <Foundation/Foundation.h>

@interface OCSpecDescriptionRunner : NSObject 
{
  Class         *classes;
  NSInteger     classCount;
  NSFileHandle  *outputter;
  id            specProtocol;
  int           successes;
  int           failures;
}

@property(nonatomic, retain) NSFileHandle *outputter;
@property(nonatomic, assign) id specProtocol;
-(void) runAllDescriptions;
@end
