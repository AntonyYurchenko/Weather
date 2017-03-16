#import "Storage.h"

@implementation Storage

- (instancetype)init {
    if (self = [super init]) {
        if (!(self.cities = [NSKeyedUnarchiver unarchiveObjectWithFile: [City arhiveURL].path])) {
            [self loadCitiesFromJson];
            [self save];
        }
    }
    
    return self;
}

- (void)loadCitiesFromJson {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    self.cities = [[NSMutableArray alloc] init];
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSArray *array = json[@"cities"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictionary in array) {
                NSString *name = [dictionary objectForKey:@"name"];
                NSString *countryCode = [dictionary objectForKey:@"countrycode"];
                NSString *descriptionCity = [dictionary objectForKey:@"description"];
                
                City *city = [[City alloc] initWithName:name countryCode:countryCode descriptionCity:descriptionCity];
                
                [self.cities addObject:city];
            }
        }
    }
}

- (void)save {
    [NSKeyedArchiver archiveRootObject:self.cities toFile:[City arhiveURL].path];
}

@end
