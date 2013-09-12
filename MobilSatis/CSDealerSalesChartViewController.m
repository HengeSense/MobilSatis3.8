//
//  CSDealerSalesChartViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 12.11.2012.
//
//

#import "CSDealerSalesChartViewController.h"

@interface CSDealerSalesChartViewController ()

@end

@implementation CSDealerSalesChartViewController
@synthesize myCustomer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDealerSalesDataFromSAP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUser:(CSUser *)myUser andCustomer:(CSCustomer*)aCustomer {
    self = [super init];
    self.myCustomer = aCustomer;
    return self;
}

- (void)getDealerSalesDataFromSAP {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_DEALER_SALES_DATA"];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:[myCustomer kunnr]];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSString *beginDate;
    NSString *endDate;
    
    if (components.month < 10)
    {
        beginDate = [NSString stringWithFormat:@"%d0%d01", components.year - 1, components.month];
        endDate = [NSString stringWithFormat:@"%d0%d01", components.year, components.month];
    }
    else
    {
        beginDate = [NSString stringWithFormat:@"%d%d01", components.year - 1, components.month];
        endDate = [NSString stringWithFormat:@"%d%d01", components.year, components.month];
    }
    
    
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:beginDate];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:endDate];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"AY", @"LITRE", @"BUTCE", nil];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithObjects:@"TYPE", @"ID", @"NUMBER", @"MESSAGE", @"LOG_NO", @"LOG_MSG_NO", @"MESSAGE_V1", @"MESSAGE_V2", @"MESSAGE_V3", @"MESSAGE_V4", @"PARAMETER", @"ROW", @"FIELD", @"SYSTEM", nil];
    NSMutableArray *arr4 = [[NSMutableArray alloc] initWithObjects:@"TABLO1_GOSTER", @"TABLO2_GOSTER", @"TABLO3_GOSTER", @"TABLO4_GOSTER", @"TABLO1_BASLIK", @"TABLO2_BASLIK", @"TABLO4_BASLIK", nil];
    
    [sapHandler addTableWithName:@"AYLIK_TABLO1" andColumns:arr2];
    [sapHandler addTableWithName:@"AYLIK_TABLO2" andColumns:arr2];
    [sapHandler addTableWithName:@"AYLIK_TABLO3" andColumns:arr2];
    [sapHandler addTableWithName:@"RETURN" andColumns:arr3];
    [sapHandler addTableWithName:@"EKBILGI" andColumns:arr4];
    [sapHandler addImportWithKey:@"I_NEW" andValue:@"X"];
    
    [sapHandler prepCall];
    
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [self refreshAll];
    header1 = @"";
    header2 = @"";
    header3 = @"";
    
    report1Texts = [[NSMutableArray alloc] init];
    report1 = [[NSMutableArray alloc] init];
    budget1 = [[NSMutableArray alloc] init];
    
    report2Texts = [[NSMutableArray alloc] init];
    report2 = [[NSMutableArray alloc] init];
    budget2 = [[NSMutableArray alloc] init];
    
    report3Texts = [[NSMutableArray alloc] init];
    report3 = [[NSMutableArray alloc] init];
    budget3 = [[NSMutableArray alloc] init];
    
    NSString *tablo1 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
    NSString *tablo2 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:1];
    NSString *tablo3 = [[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:2];
    
    NSArray *arr = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:[[ABHXMLHelper getValuesWithTag:@"BAPIRET2" fromEnvelope:myResponse] objectAtIndex:0]];
    NSArray *arr2 = [ABHXMLHelper getValuesWithTag:@"item" fromEnvelope:[[ABHXMLHelper getValuesWithTag:@"ZEYONETICI_RAPOR_EKBILGI" fromEnvelope:myResponse] objectAtIndex:0]];
    
    for (int i = 0; i < [arr count]; i++) {
        if ([[[ABHXMLHelper getValuesWithTag:@"NUMBER" fromEnvelope:[arr objectAtIndex:i]] objectAtIndex:0] isEqualToString:@"139"]) {
            NSString *ekbilgi = [arr2 objectAtIndex:i];
            
            if ([[[ABHXMLHelper getValuesWithTag:@"TABLO1_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                header1 = [[ABHXMLHelper getValuesWithTag:@"TABLO1_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo1] count] > i)
                    [self getSaleDataFromEnvelope:tablo1:i:0];
            }
            
            if ([[[ABHXMLHelper getValuesWithTag:@"TABLO2_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                header2 = [[ABHXMLHelper getValuesWithTag:@"TABLO2_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo2] count] > i)
                    [self getSaleDataFromEnvelope:tablo2:i:1];
            }
            
            if ([[[ABHXMLHelper getValuesWithTag:@"TABLO3_GOSTER" fromEnvelope:ekbilgi] objectAtIndex:0] isEqualToString:@"X"]) {
                header3 = [[ABHXMLHelper getValuesWithTag:@"TABLO3_BASLIK" fromEnvelope:ekbilgi] objectAtIndex:0];
                if ([[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:tablo3] count] > i)
                    [self getSaleDataFromEnvelope:tablo3:i:2];
            }
        }
    }
    [self refreshSales];
    
}

- (void)getSaleDataFromEnvelope:(NSString *)envelope:(int)counter:(int)sayac {
    NSString *month = [[ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:envelope] objectAtIndex:counter];
    NSString *litre = [[ABHXMLHelper getValuesWithTag:@"FIILI_GUNCEL" fromEnvelope:envelope] objectAtIndex:counter];
    NSString *budget = [[ABHXMLHelper getValuesWithTag:@"BUTCE" fromEnvelope:envelope] objectAtIndex:counter];
    
    if (sayac == 0) {
        [report1Texts addObject:month];
        [report1 addObject:litre];
        [budget1 addObject:budget];
    }
    else if(sayac == 1) {
        [report2Texts addObject:month];
        [report2 addObject:litre];
        [budget2 addObject:budget];
    }
    else if(sayac == 2) {
        [report3Texts addObject:month];
        [report3 addObject:litre];
        [budget3 addObject:budget];
    }
}

-(void) showMessageFromResponses:(NSMutableArray*)responses{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Açıklama" message:[responses objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
    [alert show];
}

- (void)refreshSales {
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
    
    self.title = @"Bayi/Dist. Satış";
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}
@end
