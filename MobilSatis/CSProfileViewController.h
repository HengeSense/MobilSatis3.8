//
//  CSProfileViewController.h
//  MobilSatis
//
//  Created by ABH on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSConfirmationListViewController.h"
#import "CSUserSalesViewController.h"
#import "CSSharePointSafariViewController.h"
#import "CSEfesPilsenCommercialsViewController.h"
#import "CSConnectWithOtherMYKViewController.h"
#import "CSESatisReportsViewController.h"
#import "CSSalesRepresentativeViewController.h"
#import "CSVisitPlanViewController.h"
#import "CSExpenseReportViewController.h"
#import "CSCampaignViewController.h"

@interface CSProfileViewController : CSBaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ABHSAPHandlerDelegate> {
    IBOutlet UILabel *welcomeLabel;
    IBOutlet UITableView *TableView;
}

@property (nonatomic, retain) UITableView *TableView;
@property (nonatomic, retain) UILabel *welcomeLabel;
@property (nonatomic, retain) NSString *defaultMyk;
@property BOOL newVersion;

- (void)viewConfirmations;
- (void)viewSales;
- (void)startUpCompleted;
@end
