//
//  EBMasterViewController.h
//  EfesBayi
//
//  Created by alp keser on 4/11/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSProfileViewController.h"
#import "CSLoctionHandlerViewController.h"
#import "CSDealerListViewController.h"
#import "CSAppDelegate.h"

@class CSBaseViewController;

@interface CSMasterViewController : UITableViewController
{
    IBOutlet UITableView *tableView;
    CSLoctionHandlerViewController *locationViewController;
    CSProfileViewController *profileViewController;
    CSDealerListViewController *dealerListViewController;
    CSUser *userInfo;
}

-(id)initWithUser:(CSUser*)myUser;

@end
