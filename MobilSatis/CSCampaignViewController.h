//
//  CSCampaignViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 26.07.2013.
//
//

#import "CSBaseViewController.h"
#import "CSCampaignDetailViewController.h"

@interface CSCampaignViewController : CSBaseViewController<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,ABHSAPHandlerDelegate>
{
    NSMutableArray *campaignTable;
    NSMutableArray *messageTable;
    IBOutlet UITableView *tableVC;
    CSUser *userMyk;
}
@end
