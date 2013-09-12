//
//  CSFinancialReportDistributorViewController.h
//  MobilSatis
//
//  Created by Ata  Cengiz on 10.05.2013.
//
//

#import <UIKit/UIKit.h>
#import "CSFinancialReport.h"
#import "ABHXMLHelper.h"
 
@interface CSRiskReportDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) CSFinancialReport *distributorFinancialReport;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
- (id)initWithReport:(CSFinancialReport *)i_report;
@end
