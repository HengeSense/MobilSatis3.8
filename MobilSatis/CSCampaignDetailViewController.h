//
//  CSCampaignDetailViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 26.07.2013.
//
//

#import "CSBaseViewController.h"

@interface CSCampaignDetailViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,ABHSAPHandlerDelegate>
{
    NSMutableArray *campaignDetail;
    IBOutlet UITableView *tableVC;
    CSUser *userMyk;
    NSString *campaignNo;
    
}

- (id)initWithUser:(CSUser *)myUser andCampaignId:(NSString*)campaignId;
@end
