//
//  CSCampaignDetailViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 26.07.2013.
//
//

#import "CSCampaignDetailViewController.h"

@interface CSCampaignDetailViewController ()

@end

@implementation CSCampaignDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser andCampaignId:(NSString*)campaignId
{
    NSString *nibName;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nibName = @"CSCampaignDetailViewController_Ipad";
    }
    else
    {
        nibName = @"CSCampaignDetailViewController";
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    
    userMyk = myUser;
    campaignNo = campaignId;
    
    return self;
}

- (void)getCampaignDetail{
    [super playAnimationOnView:self.view];
//    NSString *currentTable    = [NSString stringWithFormat:@"ET_KAMPANYA"];
//    NSMutableArray *columns   = [[NSMutableArray alloc] init];
//    
//    [columns addObject:@"ZKMID"];
//    [columns addObject:@"ZKMTX"];
//    [columns addObject:@"DATAB"];
//    [columns addObject:@"DATBI"];
//    [columns addObject:@"ZMING"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getR3Destination] andSystemNumber:[ABHConnectionInfo getR3SystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZSD_KAMPANYA_GET_PERS_STATUS"];
    
    [sapHandler addImportWithKey:@"IV_KUNNR" andValue:userMyk.username];
    [sapHandler addImportWithKey:@"IV_KMPID" andValue:campaignNo];
    
    [sapHandler setDelegate:self];
    
//    [sapHandler addTableWithName:currentTable andColumns:columns];
    [sapHandler prepCall];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me
{

        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ES_RESULT" fromEnvelope:myResponse];
        
        NSMutableArray *butce   = [[NSMutableArray alloc] init];
        NSMutableArray *fiili   = [[NSMutableArray alloc] init];
        NSMutableArray *oran    = [[NSMutableArray alloc] init];
        NSMutableArray *gereken = [[NSMutableArray alloc] init];
        NSMutableArray *gunctar = [[NSMutableArray alloc] init];
        NSMutableArray *guncsaat = [[NSMutableArray alloc] init];
    
    
        butce   = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:[responses objectAtIndex:0]];
        fiili   = [ABHXMLHelper getValuesWithTag:@"FIILI" fromEnvelope:[responses objectAtIndex:0]];
        oran    = [ABHXMLHelper getValuesWithTag:@"ORAN" fromEnvelope:[responses objectAtIndex:0]];
        gereken = [ABHXMLHelper getValuesWithTag:@"GEREKEN" fromEnvelope:[responses objectAtIndex:0]];
        gunctar = [ABHXMLHelper getValuesWithTag:@"CPUDT" fromEnvelope:[responses objectAtIndex:0]];
        guncsaat = [ABHXMLHelper getValuesWithTag:@"CPUTM" fromEnvelope:[responses objectAtIndex:0]];
    
    
        
        if ([butce count] > 0) {
            
            for (int sayac = 0; sayac<[butce count]; sayac++) {
                
                NSString *userButce   = [butce objectAtIndex:sayac];
                NSString *userFiili   = [fiili objectAtIndex:sayac];
                NSString *userOran    = [oran objectAtIndex:sayac];
                NSString *userGereken = [gereken objectAtIndex:sayac];
                NSString *guncelTarih = [gunctar objectAtIndex:sayac];
                NSString *guncelSaat  = [guncsaat objectAtIndex:sayac];
                
                NSArray  *arr = [NSArray arrayWithObjects:userButce,userFiili,userOran,userGereken,guncelTarih,guncelSaat,nil];
                
                [campaignDetail addObject:arr];
            }
        }
    
        [tableVC reloadData];
        [super stopAnimationOnView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setLocale:[NSLocale systemLocale]];
    NSDate *date = [formatter dateFromString:[[campaignDetail objectAtIndex:0] objectAtIndex:4]];
    
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *message = [NSString stringWithFormat:@"%@%@%@%@%@",@"Bu raporun içeriği ", dateString,@" ", [[campaignDetail objectAtIndex:0] objectAtIndex:5], @" tarihinde kaydedilmiştir."];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message: message delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
    
    [alert show];
    return;
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];
    
    if ([campaignDetail count] > 0)
    {
    switch (indexPath.row) {
        case 0:
            [[cell textLabel] setText:@"Bütçe"];
            [[cell detailTextLabel] setText:[ABHXMLHelper correctNumberValue:[[campaignDetail objectAtIndex:0] objectAtIndex:indexPath.row]]];
            break;
        case 1:
            [[cell textLabel] setText:@"Fiili"];
            [[cell detailTextLabel] setText:[ABHXMLHelper correctNumberValue:[[campaignDetail objectAtIndex:0] objectAtIndex:indexPath.row]]];
            break;
        case 2:
            [[cell textLabel] setText:@"Gerç.Oranı(%)"];
            [[cell detailTextLabel] setText:[ABHXMLHelper correctNumberValueWithDecimal:[[campaignDetail objectAtIndex:0] objectAtIndex:indexPath.row]]];
            break;
        case 3:
            [[cell textLabel] setText:@"Gereken"];
            [[cell detailTextLabel] setText:[ABHXMLHelper correctNumberValue:[[campaignDetail objectAtIndex:0] objectAtIndex:indexPath.row]]];
            break;
        default:
            break;
    }
    }
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Kampanyalar"];
    
    tableVC.backgroundColor = [UIColor clearColor];
    tableVC.opaque = NO;
    tableVC.backgroundView = nil;
    
    campaignDetail = [[NSMutableArray alloc] init];
    [self getCampaignDetail];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
