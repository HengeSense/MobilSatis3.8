//
//  CSPartnersForVisitViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 28.06.2013.
//
//

#import "CSBaseViewController.h"
#import "CSVisitPartners.h"
#import "CSVisitPlanViewController.h"

@interface CSPartnersForVisitViewController : CSBaseViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,ABHSAPHandlerDelegate>

{
    NSMutableArray *partnerForVisit;
    NSMutableArray *selectedIndex;
    NSString *partnerSplit;
    CSVisitPartners *partners;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIPickerView *myPicker;

- (id)initWithDist:(NSString *)bayi anOrg:(NSString *)org anMusttur:(NSString *)musttur anMustgrp:(NSString *)mustgrp anMustozl:(NSString *)mustozl anLitre:(NSString *)litre anMyk:(NSString *)myk;
@end
