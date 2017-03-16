#import <Foundation/Foundation.h>
#import "City.h"

@interface Storage : NSObject

@property NSMutableArray *cities;

- (instancetype)init;

- (void)save;

@end
