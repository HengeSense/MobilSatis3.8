//
//  CSUserSalesViewController.h
//  MobilSatis
//
//  Created by ABH on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUserSaleData.h"
#import "CSUserSalesDetailsViewController.h"
#import "CSProfileSalesChartViewController.h"

@interface CSUserSalesViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    IBOutlet UITableView *table;
    IBOutlet UIPickerView *myPicker;
    IBOutlet UIButton *goChartButton;
    NSMutableArray *report1;
    NSMutableArray *report2;
    NSMutableArray *report3;
    NSMutableArray *projection1;
    NSMutableArray *titles;
    NSMutableArray *chartDataArray;
     int fark;
    NSNumberFormatter * numberFormatter;
    
    NSMutableArray *chartReport1;
    NSMutableArray *chartReport1Texts;
    NSMutableArray *chartReport2;
    NSMutableArray *chartReport2Texts;
    NSMutableArray *chartReport3;
    NSMutableArray *chartReport3Texts;
    NSString *chartHeader1;
    NSString *chartHeader2;
    NSString *chartHeader3;
}

@property (nonatomic, retain) NSString *saleMessage;

- (void)getSalesDataOfUser:(CSUser*)aUser;
- (void)getTitlesFormEnvelope:(NSString*)envelope;
- (IBAction)goToChart:(id)sender;
- (NSString*)findTotalCurrentRateFromArray:(NSMutableArray*)anArray;
- (NSUInteger)calculateNumberOfTitles:(NSMutableArray*)titles;
@end
