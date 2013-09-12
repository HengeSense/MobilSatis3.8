//
//  CSExpenseReportViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 03.07.2013.
//
//

#import "CSBaseViewController.h"
#import "CSExpenseDetailReportViewController.h"

@interface CSExpenseReportViewController : CSBaseViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,ABHSAPHandlerDelegate>

{
    NSMutableArray *expenseReport;
    NSMutableArray *currentCollective;
    NSMutableArray *currentCollectiveDistinct;
    NSMutableArray *lastCollective;
    NSMutableArray *expenseReportMonth;
    CSUser *userMyk;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIPickerView *myPicker;

@end
