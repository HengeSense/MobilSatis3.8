//
//  CSUserSaleDataViewController.h
//  MobilSatis
//
//  Created by Alp Keser on 6/13/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUserSaleData.h"
#import "makit.h"
#import "ChartQuery.h"

@interface CSUserSaleDataViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate, ABHSAPHandlerDelegate>{
    IBOutlet UITableView *table;
    CSUserSaleData *userSaleData;
    NSString *title;
    NSString *beginDate;
    NSString *endDate;
    
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
}

- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString*)aTitle andBeginDate:(NSString*)aBegin andEndDate:(NSString*)aEnd;

@end
