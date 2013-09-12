//
//  CSVisitPlanViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 26.06.2013.
//
//

#import "CSBaseViewController.h"
#import "CSUser.h"
#import "CSPartnersForVisitViewController.h"

@interface CSVisitPlanViewController : CSBaseViewController < UITableViewDataSource, CLLocationManagerDelegate,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate >
{
    CSUser *userMyk;
    NSMutableArray *mudurPickerList;
    NSMutableArray *bayiPickerList;
    NSMutableArray *orgPickerList;
    NSMutableArray *mustturPickerList;
    NSMutableArray *mustozlPickerList;
    NSMutableArray *mustgrpPickerList;
    NSMutableArray *litrePickerList;
    
    UIButton *button;
    
    NSString *mdrRow;
    NSString *bayiRow;
    NSString *orgRow;
    NSString *mustturRow;
    NSString *mustgrpRow;
    NSString *mustozlRow;
    NSString *litreRow;
    
    NSString *mdr;
    NSString *bayi;
    NSString *org;
    NSString *musttur;
    NSString *mustgrp;
    NSString *mustozl;
    NSString *litre;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIPickerView *activePickerView;

-(IBAction)hidePicker:(id)sender;

- (id)initWithUser:(CSUser *)myUser;
@end
