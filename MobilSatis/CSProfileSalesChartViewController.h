//
//  CSProfileSalesChartViewController.h
//  MobilSatis
//
//  Created by alp keser on 9/17/12.
//
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSGraphData.h"
#import "makit.h"
#import "ChartQuery.h"

@interface CSProfileSalesChartViewController : MAViewController <ABHSAPHandlerDelegate>{
    NSMutableArray *report1;
    NSMutableArray *budget1;
    NSMutableArray *report1Texts;
    NSMutableArray *report2;
    NSMutableArray *budget2;
    NSMutableArray *report2Texts;
    NSMutableArray *report3;
    NSMutableArray *budget3;
    NSMutableArray *report3Texts;
    NSString *header1;
    NSString *header2;
    NSString *header3;
    NSMutableArray *monthTexts;
    NSString *lastYearSale;
    NSString *thisYearSale;
    NSString *beginDate;
    NSString *endDate;
}

- (id)initWithUser:(CSUser *)myUser andBeginDate:(NSString*)begin andEndDate:(NSString*)end;
- (void)getSalesData;
- (void)initLastMonth;
- (void)initLastSixMonths;


@end
