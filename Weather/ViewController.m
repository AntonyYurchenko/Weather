#import "ViewController.h"
#import "Storage.h"

@interface ViewController () {
    NSString *_appId;
    BOOL _animationFlag;
    CGRect _sourceTextViewFrame;
    CGRect _sourceTableViewFrame;
    double _oneKelvin;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storage = [[Storage alloc] init];
    self.tableView.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"credentials" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _appId = [json objectForKey:@"appid"];
    
    _animationFlag = NO;
    _oneKelvin = 273.15;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _sourceTextViewFrame = self.textView.frame;
    _sourceTableViewFrame = self.tableView.frame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storage.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Value1TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    City *city = [self.storage.cities objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.countryCode;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = [self.storage.cities objectAtIndex:indexPath.row];
    self.textView.text = [self createTextWithCity:city];
    
    NSDate *now = [NSDate date];
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:city.date];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    if (hoursBetweenDates >= 1 || city.date == nil)
        [self updateWeatherWithCity:city index:indexPath.row];
}

- (void)updateWeatherWithCity: (City*)city index: (NSInteger)index {
    NSMutableString *url = [NSMutableString string];
    [url appendString: @"http://api.openweathermap.org/data/2.5/weather?q="];
    [url appendString: city.name];
    [url appendString: @","];
    [url appendString: city.countryCode];
    [url appendString: @"&APPID="];
    [url appendString: _appId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@",[error localizedDescription]);
            return;
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode != 200) {
            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
            return;
        }
        
        if ([response.MIMEType  containsString:@"json"] && data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];;
            
            if ([json isKindOfClass:[NSDictionary class]]) {
                double doubleTemp = [[[json objectForKey:@"main"] objectForKey:@"temp"] doubleValue] - _oneKelvin;
                int temp = (int)doubleTemp;
                city.temp = [[NSNumber numberWithInteger:temp] stringValue];
                
                NSArray *array = json[@"weather"];
                if ([array isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dictionary in array) {
                        city.weatherDescription = [dictionary objectForKey:@"main"];;
                    }
                }
            }
            
            city.date = [NSDate date];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [self createTextWithCity:city];
            });
            
            [self.storage.cities replaceObjectAtIndex:index withObject:city];
            [self.storage save];
        } else {
            NSLog(@"dataTaskWithRequest response mime: %@", response.MIMEType);
        }
        
    }];
    [task resume];
}

- (NSString*)createTextWithCity: (City*) city {
    NSMutableString *text = [NSMutableString string];
    [text appendString: @"About city: "];
    [text appendString: city.descriptionCity];
    [text appendString: @"\n"];
    if (city.temp) {
        [text appendString: @"\nTemperature: "];
        [text appendString: city.temp];
        [text appendString: @" C"];
    }
    if (city.weatherDescription) {
        [text appendString: @"\nDescription: "];
        [text appendString: city.weatherDescription];
    }
    
    return text;
}

- (IBAction)textViewTap:(id)sender {
    [UITextView animateWithDuration:0.5 animations: ^{
        if (!_animationFlag)
            self.textView.frame = CGRectMake(_sourceTextViewFrame.origin.x, _sourceTextViewFrame.origin.y, _sourceTextViewFrame.size.width, [self percentage:60]);
        else
            self.textView.frame = _sourceTextViewFrame;
        
        if (!_animationFlag) {
            self.tableView.frame = CGRectMake(_sourceTableViewFrame.origin.x, [self percentage:60], _sourceTableViewFrame.size.width, [self percentage:40]);
        } else {
            self.tableView.frame = _sourceTableViewFrame;
        }
    }];
    
    _animationFlag = !_animationFlag;
}

- (int) percentage: (int) percentage {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    return (percentage*screenHeight)/100;
}

@end
