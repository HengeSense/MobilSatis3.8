//
//  CSCustomerSalesChartViewController.m
//  MobilSatis
//
//  Created by ABH on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSCustomerSalesChartViewController.h"

@implementation CSCustomerSalesChartViewController
@synthesize thisYearSale;
@synthesize lastYearSale;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andSelectedCustomer:(CSCustomer*)selectedCustomer{
    self = [super init];
    customer = selectedCustomer;
    
    return  self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //    [self adjustViewsForOrientation:toInterfaceOrientation];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        //      titleImageView.center = CGPointMake(235.0f, 42.0f);
        //    subtitleImageView.center = CGPointMake(355.0f, 70.0f);
        //  ...
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // titleImageView.center = CGPointMake(160.0f, 52.0f);
        //subtitleImageView.center = CGPointMake(275.0f, 80.0f);
        // ...
    }
}

- (void)getSalesData {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getBWHostName] andClient:[ABHConnectionInfo getBWClient] andDestination:[ABHConnectionInfo getBWDestination] andSystemNumber:[ABHConnectionInfo getBWSystemNumber] andUserId:[ABHConnectionInfo getBWUserId] andPassword:[ABHConnectionInfo getBWPassword] andRFCName:@"ZMOB_GET_SALE_DATA"];					
    //[sapHandler addImportWithKey:@"I_UNAME" andValue:user.username];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:customer.kunnr];
    [sapHandler addTableWithName:@"T_LITRE" andColumns:[NSMutableArray arrayWithObjects:@"AY",@"LITRE", nil]];
    [sapHandler addTableWithName:@"T_MLITRE" andColumns:[NSMutableArray arrayWithObjects:@"MATERIAL",@"TANIM",@"LITRE", nil]];
    [sapHandler addImportWithKey:@"I_NEW" andValue:@"X"];
    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {    
    @try {
        [self initLastSixMonths:[[ABHXMLHelper getValuesWithTag:@"ZMOB_AYLIK_LITRE" fromEnvelope:myResponse] objectAtIndex:0]];
        self.lastYearSale = [[ABHXMLHelper getValuesWithTag:@"E_ESKI_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
        self.thisYearSale = [[ABHXMLHelper getValuesWithTag:@"E_YILLIK_SATIS" fromEnvelope:myResponse] objectAtIndex:0];
        [self refreshSales];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Beklenmeyen bir hata oluştu tekrar deneyiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
        [alert show];
        [[self navigationController] popViewControllerAnimated:YES];
    }

}

- (void)initLastSixMonths:(NSString*)envelope{
    NSMutableArray *monthArray = [ABHXMLHelper getValuesWithTag:@"AY" fromEnvelope:envelope];
    NSMutableArray *literArray = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:envelope];
    
    sixMonthData = [[NSMutableArray alloc] init];
    sixMonthTexts = [[NSMutableArray alloc] init];

    for (int i = 0; i < [monthArray count]; i++) {
        [sixMonthData addObject:[literArray objectAtIndex:i]];
        [sixMonthTexts  addObject:[monthArray objectAtIndex:i]];
    }
}

- (void)refreshSales {
    ChartQuery *query = [[ChartQuery alloc] init];
    [query setReport1:sixMonthData];
    [query setReport1Text:sixMonthTexts];
    
    self.title = @"Müşteri Satışları";
    self.metaDataPath = [[NSBundle mainBundle] pathForResource:@"CustomerSalesMetaData" ofType:@"xml"];
    self.theme = [[MAKitTheme_WelterWeight alloc] init];
    self.dataSource = query;
    [self.navigationItem setTitleView:nil];
    
    [self refresh];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getSalesData];
    
    ChartQuery *query = [[ChartQuery alloc] init];
    [query setReport1:sixMonthData];
    [query setReport1Text:sixMonthTexts];
    
    self.title = @"Müşteri Satışları";
    self.metaDataPath = [[NSBundle mainBundle] pathForResource:@"CustomerSalesMetaData" ofType:@"xml"];
    self.theme = [[MAKitTheme_WelterWeight alloc] init];
    self.dataSource = query;
    [self.navigationItem setTitleView:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
