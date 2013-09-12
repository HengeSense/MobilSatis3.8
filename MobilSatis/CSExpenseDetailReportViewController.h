//
//  CSExpenseDetailReportViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 05.07.2013.
//
//

#import "CSBaseViewController.h"
#import "CSExpenseReportViewController.h"

@interface CSExpenseDetailReportViewController : CSBaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *expensesReport;
    NSString *title;
}
@property (nonatomic,retain) IBOutlet UITableView *tableView;

-(id)initWithArray:(NSMutableArray *)table andNibName:(NSString *)nibName andDescription:(NSString*)description;
@end
