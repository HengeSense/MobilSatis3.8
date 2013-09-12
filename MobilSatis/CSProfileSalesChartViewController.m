//
//  CSProfileSalesChartViewController.m
//  MobilSatis
//
//  Created by alp keser on 9/17/12.
//
//

#import "CSProfileSalesChartViewController.h"

@interface CSProfileSalesChartViewController ()

@end

@implementation CSProfileSalesChartViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andBeginDate:(NSString*)begin andEndDate:(NSString*)end{
    self = [super init];
    beginDate = [NSString stringWithFormat:@"%@",begin];
    endDate = [NSString stringWithFormat:@"%@",end];
    return self;
}
-(void) showMessageFromResponses:(NSMutableArray*)responses{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[responses objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
    [alert show];
}
- (void)getSalesDataOfUser {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_MYK_AYLIKKUMULE"];
    [sapHandler addImportWithKey:@"I_MYK" andValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
    [sapHandler addImportWithKey:@"SORGU_BASLANGIC" andValue:beginDate];
    [sapHandler addImportWithKey:@"SORGU_BITIS" andValue:endDate];
    
    NSString *tableName = [NSString stringWithFormat:@"TABLO1"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"FIILI_GECMIS"];
    [columns addObject:@"FIILI_GUNCEL"];
    [columns addObject:@"GELISME"];
    [columns addObject:@"BUTCE"];
    [columns addObject:@"ORAN_GERC_BUTCE"];
    
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO2"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    tableName = [NSString stringWithFormat:@"TABLO3"];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [self refreshAll];
    
    [self showMessageFromResponses:[ABHXMLHelper getValuesWithTag:@"MESSAGE" fromEnvelope:myResponse]];
    int sayac = 0;
    header1 =@"";
    header2 =@"";
    header3 =@"";
    if ([[[ABHXMLHelper getValuesWithTag:@"TABLO1_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
        header1 = [NSString stringWithFormat:@"%@",[[ABHXMLHelper getValuesWithTag:@"TABLO1_BASLIK" fromEnvelope:myResponse] objectAtIndex:0] ];
        report1Texts = [[NSMutableArray alloc] init];
        report1 = [[NSMutableArray alloc] init];
        budget1 = [[NSMutableArray alloc] init];
        [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:sayac] intoArray:&report1 andTexts:&report1Texts andBudgets:&budget1];
        sayac++;
    }
    if ([[[ABHXMLHelper getValuesWithTag:@"TABLO2_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
        header2 = [[ABHXMLHelper getValuesWithTag:@"TABLO2_BASLIK" fromEnvelope:myResponse] objectAtIndex:0];
        report2Texts = [[NSMutableArray alloc] init];
        report2 = [[NSMutableArray alloc] init];
        budget2 = [[NSMutableArray alloc] init];
        [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:sayac] intoArray:&report2 andTexts:&report2Texts andBudgets:&budget2];
        sayac++;
    }
    if ([[[ABHXMLHelper getValuesWithTag:@"TABLO3_GOSTER" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"X"]) {
        header3 = [[ABHXMLHelper getValuesWithTag:@"TABLO3_BASLIK" fromEnvelope:myResponse] objectAtIndex:0];
        report3Texts = [[NSMutableArray alloc] init];
        report3 = [[NSMutableArray alloc] init];
        budget3 = [[NSMutableArray alloc] init];
        [self parseResponse:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:2] intoArray:&report3 andTexts:&report3Texts andBudgets:&budget3];
    }
    [self showSales];
}

-(void)parseResponse:(NSString*)response intoArray:(NSMutableArray*__strong *)array andTexts:(NSMutableArray*__strong *)texts andBudgets:(NSMutableArray*__strong*)budgets{
    *texts = [[NSMutableArray alloc] initWithArray:[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:response] copyItems:NO];
    *budgets = [ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:response];
    *array = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:response];
}

- (void)showSales {
    ChartQuery *query = [[ChartQuery alloc] init];
    [query setReport1:report1];
    [query setReport2:report2];
    [query setReport3:report3];
    [query setReport1Text:report1Texts];
    [query setReport2Text:report2Texts];
    [query setReport3Text:report3Texts];
    [query setHeader1:header1];
    [query setHeader2:header2];
    [query setHeader3:header3];
    self.title = @"Efes Satışlarım";
    self.metaDataPath = [[NSBundle mainBundle] pathForResource:@"SalesMetadata" ofType:@"xml"];
    self.theme = [[MAKitTheme_WelterWeight alloc] init];
    self.dataSource = query;
    [self.navigationItem setTitleView:nil];
    [self refresh];
}

- (void)refreshAll{
    [report1 removeAllObjects];
    [report2 removeAllObjects];
    [report3 removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getSalesDataOfUser];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
