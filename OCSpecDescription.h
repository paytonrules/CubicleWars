#import <Foundation/Foundation.h>

@interface OCSpecDescription : NSObject 
{
  NSInteger     errors;
  NSInteger     successes;
  NSFileHandle  *outputter;
  NSArray       *itsExamples;
  NSString      *itsName;
}

@property(assign) NSInteger errors;
@property(assign) NSInteger successes;
@property(nonatomic, retain) NSFileHandle *outputter;
// NOTE - this describe is probably deletable!
-(void) describe:(NSString *)name onArrayOfExamples:(NSArray *) examples;
-(void) describe;
-(id) initWithName:(NSString *) name examples:(NSArray *)examples;

@end

// Note - the ARRAY and IDARRAY macros are grabbed from MACollectionUtilities by mike ash - 
// I don't really need the rest of the MACollectionUtilities, but proper credit where credit is due and such.
// https://github.com/mikeash/MACollectionUtilities/blob/master/MACollectionUtilities.h
#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
#define IDARRAY(...) ((id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))


                                      
