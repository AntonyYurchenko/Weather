#import <UIKit/UIKit.h>
#import "Storage.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property Storage *storage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

