//
//  CSESatisReportsViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 16.05.2013.
//
//

#import "CSBaseViewController.h"
#import "CSRiskReportViewController.h"
#import "CSSharePointSafariViewController.h"
#import "CSConnectWithOtherMYKViewController.h"

@interface CSESatisReportsViewController : CSBaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (id)initWithUser:(CSUser *)myUser;
@end
