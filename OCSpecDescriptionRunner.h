#import <Foundation/Foundation.h>
#import "DescriptionRunner.h"
#import "OCSpecDescription.h"

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
@property(readonly) int successes;
@property(readonly) int failures;

-(void) runAllDescriptions;
@end

#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
#define IDARRAY(...) ((id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define DESCRIBE(description, ...) \
static OCSpecDescription *desc__FILE____LINE__; \
@interface TestRunner : NSObject<DescriptionRunner> \
@end \
@implementation TestRunner \
  +(void) run \
  { \
    desc__FILE____LINE__ = [[[OCSpecDescription alloc] initWithName:description examples:ARRAY(__VA_ARGS__)] autorelease]; \
    [desc__FILE____LINE__ describe]; \
  } \
  +(NSNumber *)getFailures \
  { \
    return [NSNumber numberWithInt:0];\
  } \
  +(NSNumber *)getSuccesses \
  { \
    return [NSNumber numberWithInt:[desc__FILE____LINE__ successes]];\
  } \
@end

