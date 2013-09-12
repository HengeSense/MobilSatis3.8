//
//  CSFinancialReportViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import "CSBaseViewController.h"
#import "ESatisHandler.h"
#import "CSFinancialReport.h"
#import "CSRiskReportDetailViewController.h"
#import "CSUser.h"

@interface CSRiskReportViewController : CSBaseViewController < UITableViewDataSource, UITableViewDelegate, ESatisHandlerDelegate, UIPickerViewDataSource, UIPickerViewDelegate >
{
    CSFinancialReport *generalFinanceReport;
    NSMutableArray *distrList;
    NSString *responseBuffer;
    NSMutableArray *pickerViewList;
    int selectedRow;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

- (void)pickerViewRowSelected:(id)sender;
- (id)initWithUser:(CSUser *)myUser;

@end
