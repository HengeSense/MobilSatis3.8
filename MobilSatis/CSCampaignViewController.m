//
//  CSCampaignViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 26.07.2013.
//
//

#import "CSCampaignViewController.h"

@interface CSCampaignViewController ()

@end

@implementation CSCampaignViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithUser:(CSUser *)myUser{
    NSString *nibName;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        nibName = @"CSCampaignViewController_Ipad";
    }else{
        nibName = @"CSCampaignViewController";
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    userMyk = myUser;
    return self;
}

- (void)getCampaignDataFromR3
{
    [super playAnimationOnView:self.view];
    NSString *currentTable    = [NSString stringWithFormat:@"ET_KAMPANYA"];
    NSMutableArray *columns   = [[NSMutableArray alloc] init];
    
    [columns addObject:@"ZKMID"];
    [columns addObject:@"ZKMTX"];
    [columns addObject:@"DATAB"];
    [columns addObject:@"DATBI"];
    [columns addObject:@"ZMING"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getR3Destination] andSystemNumber:[ABHConnectionInfo getR3SystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZSD_KAMPANYA_GET_LIST"];
    
    [sapHandler setDelegate:self];
    
    [sapHandler addTableWithName:currentTable andColumns:columns];
    [sapHandler prepCall];
    
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me
{
    NSRange range = [myResponse rangeOfString:@"item"];
    if (range.length > 0)
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZSD_T_KAMPANYA_B" fromEnvelope:myResponse];
        NSMutableArray *responses2 = [ABHXMLHelper getValuesWithTag:@"ZSD_S_MESSAGE" fromEnvelope:myResponse];
        
        NSMutableArray *campId   = [[NSMutableArray alloc] init];
        NSMutableArray *campName = [[NSMutableArray alloc] init];
        NSMutableArray *begda    = [[NSMutableArray alloc] init];
        NSMutableArray *endda    = [[NSMutableArray alloc] init];
        NSMutableArray *perc     = [[NSMutableArray alloc] init];
        NSMutableArray *messageId = [[NSMutableArray alloc] init];
        NSMutableArray *message  = [[NSMutableArray alloc] init];
        
        campId   = [ABHXMLHelper getValuesWithTag:@"ZKMID" fromEnvelope:[responses objectAtIndex:0]];
        campName = [ABHXMLHelper getValuesWithTag:@"ZKMTX" fromEnvelope:[responses objectAtIndex:0]];
        begda    = [ABHXMLHelper getValuesWithTag:@"DATAB" fromEnvelope:[responses objectAtIndex:0]];
        endda    = [ABHXMLHelper getValuesWithTag:@"DATBI" fromEnvelope:[responses objectAtIndex:0]];
        perc     = [ABHXMLHelper getValuesWithTag:@"ZMING" fromEnvelope:[responses objectAtIndex:0]];
        
        if ([responses2 count] > 0)
        {
            messageId = [ABHXMLHelper getValuesWithTag:@"ZKMID" fromEnvelope:[responses2 objectAtIndex:0]];
            message   = [ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:[responses2 objectAtIndex:0]];
        }
        
        if ([campId count] > 0) {
            
            for (int sayac = 0; sayac<[campId count]; sayac++) {
                
                NSString *campaignId   = [campId objectAtIndex:sayac];
                NSString *campaignName = [campName objectAtIndex:sayac];
                NSString *beginDate    = [begda objectAtIndex:sayac];
                NSString *endDate      = [endda objectAtIndex:sayac];
                NSString *campaignPerc = [perc objectAtIndex:sayac];
                
                NSArray  *arr = [NSArray arrayWithObjects:campaignId,campaignName,beginDate,endDate,campaignPerc,nil];
                
                [campaignTable addObject:arr];
            }
        }
        
        if ([message count] > 0)
        {
            for (int i = 0; i < [message count]; i++)
            {
                NSString *msgId = [message objectAtIndex:i];
                NSString *msg = [message objectAtIndex:i];
                
                NSArray  *arr2 = [NSArray arrayWithObjects:msgId,msg,nil];
                
                [messageTable addObject:arr2];
            }
        }
        
        [tableVC reloadData];
        [super stopAnimationOnView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:[[messageTable objectAtIndex:0] objectAtIndex:1]delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        alert.tag = 2;
    }
    else
    {
        [super stopAnimationOnView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Güncel kampanya bulunamamıştır!" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        alert.tag = 1;
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0) {
                [[self navigationController] popViewControllerAnimated:YES];
            }
            break;
        case 2:
            if (buttonIndex == 0)
            {
                if ([messageTable count] > 0)
                {
                    [messageTable removeObjectAtIndex:0];
                    if ([messageTable count] > 0) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:[[messageTable objectAtIndex:0] objectAtIndex:1] delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
                        
                        alert.tag = 2;
                    }
                }
            }
            break;
        default:
            break;
    }
    
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [campaignTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];
    
    [[cell textLabel] setText:[[campaignTable objectAtIndex:indexPath.row] objectAtIndex:1]];
    [[cell textLabel]setFont:[UIFont boldSystemFontOfSize:15]];
    
    [[cell detailTextLabel] setText:[NSString stringWithFormat: @"Gereken Min. Gerç: %@%@",[[campaignTable objectAtIndex:indexPath.row] objectAtIndex:4],@"%"]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *campaignId = [[campaignTable objectAtIndex:indexPath.row] objectAtIndex:0];
    
    CSCampaignDetailViewController *campaignDetail = [[CSCampaignDetailViewController alloc] initWithUser:userMyk andCampaignId:campaignId];
    
    [[self navigationController] pushViewController:campaignDetail animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Kampanyalar"];
    
    tableVC.backgroundColor = [UIColor clearColor];
    tableVC.opaque = NO;
    tableVC.backgroundView = nil;
    
    campaignTable = [[NSMutableArray alloc] init];
    messageTable = [[NSMutableArray alloc] init];
    
    [self getCampaignDataFromR3];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
