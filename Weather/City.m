#import "City.h"

@implementation City

+ (NSURL *)arhiveURL {
    static NSURL *url = nil;
    if (url == nil) {
        NSURL *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
        url = [paths URLByAppendingPathComponent:@"cities"];
    }
    return url;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *countryCode = [aDecoder decodeObjectForKey:@"countrycode"];
    NSString *descriptionCity = [aDecoder decodeObjectForKey:@"description"];
    NSString *temp = [aDecoder decodeObjectForKey:@"temp"];
    NSString *weatherDescription = [aDecoder decodeObjectForKey:@"weatherdescription"];
    NSDate *date = [aDecoder decodeObjectForKey:@"date"];
    
    return [self initWithName:name countryCode:countryCode descriptionCity:descriptionCity temp:temp weatherDescription:weatherDescription date:date];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.countryCode forKey:@"countrycode"];
    [aCoder encodeObject:self.descriptionCity forKey:@"description"];
    [aCoder encodeObject:self.temp forKey:@"temp"];
    [aCoder encodeObject:self.weatherDescription forKey:@"weatherdescription"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (instancetype) initWithName: (NSString*) name countryCode: (NSString*) countryCode descriptionCity: (NSString*) descriptionCity {
    if (self = [super init]) {
        self.name = name;
        self.countryCode = countryCode;
        self.descriptionCity = descriptionCity;
    }
    
    return self;
}

- (instancetype) initWithName: (NSString*) name countryCode: (NSString*) countryCode descriptionCity: (NSString*) descriptionCity temp: (NSString*) temp weatherDescription: (NSString*) weatherDescription date: (NSDate*) date {
    if (self = [super init]) {
        self.name = name;
        self.countryCode = countryCode;
        self.descriptionCity = descriptionCity;
        self.temp = temp;
        self.weatherDescription = weatherDescription;
        self.date = date;
    }
    
    return self;
}

@end
