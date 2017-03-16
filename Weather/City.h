#import <Foundation/Foundation.h>

@interface City : NSObject<NSCoding>

@property NSString *name;
@property NSString *countryCode;
@property NSString *descriptionCity;
@property NSString *temp;
@property NSString *weatherDescription;
@property NSDate *date;

+ (NSURL *)arhiveURL;

- (instancetype) initWithName: (NSString*) name countryCode: (NSString*) countryCode descriptionCity: (NSString*) descriptionCity;

- (instancetype) initWithName: (NSString*) name countryCode: (NSString*) countryCode descriptionCity: (NSString*) descriptionCity temp: (NSString*) temp weatherDescription: (NSString*) weatherDescription date: (NSDate*) date;

@end
