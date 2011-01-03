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

#define DESCRIBE(classname, ...)\
static OCSpecDescription *desc##classname;\
@interface TestRunner##classname : NSObject<DescriptionRunner>\
@end\
@implementation TestRunner##classname\
+(void) run \
{ \
desc##classname = [[[OCSpecDescription alloc] initWithName:@"##classname" examples:ARRAY(__VA_ARGS__)] autorelease]; \
[desc##classname describe]; \
} \
+(NSNumber *)getFailures \
{ \
return [NSNumber numberWithInt:[desc##classname errors]];\
} \
+(NSNumber *)getSuccesses \
{ \
return [NSNumber numberWithInt:[desc##classname successes]];\
} \
@end
