//
//  CSCustomerSalesChartViewController.h
//  MobilSatis
//
//  Created by ABH on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSCustomer.h"
#import "makit.h"
#import "ChartQuery.h"

@interface CSCustomerSalesChartViewController : MAViewController <ABHSAPHandlerDelegate> {
    NSMutableArray *sixMonthData;
    NSMutableArray *sixMonthTexts; 
    CSCustomer *customer;
    NSString *lastYearSale;
    NSString *thisYearSale;
}
@property (nonatomic, retain) NSString *lastYearSale;
@property (nonatomic, retain) NSString *thisYearSale;

- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer;
- (void)getSalesData;
- (void)initLastSixMonths;

@end
