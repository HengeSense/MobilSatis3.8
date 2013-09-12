//
//  CSUserSaleDataViewController.m
//  MobilSatis
//
//  Created by Alp Keser on 6/13/12.
//  Copyright (c) 2012 Abh. All rights reserved.
//

#import "CSUserSaleDataViewController.h"

@interface CSUserSaleDataViewController ()

@end

@implementation CSUserSaleDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser andUserSaleData:(CSUserSaleData*)anUserSaleData andTitle:(NSString *)aTitle andBeginDate:(NSString *)aBegin andEndDate:(NSString *)aEnd{
    self = [super initWithUser:myUser];
    userSaleData = anUserSaleData;
    title = aTitle;
    beginDate = aBegin;
    endDate = aEnd;
    
    return self;
}

#pragma mark - Table Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
        return 120;
    else
        return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else {
        [[cell detailTextLabel] setText:@""];
        [cell setAccessoryView:nil];
    }
    int sayac = 0;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    CSUserSaleData *tempSaleData;
    
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RowStyle-20.png"]];
    
    //[cell setTextColor:[CSApplicationProperties getUsualTextColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
    {
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:20]];
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:16]];
    }
    
    
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gerçekleşen Geçmiş";
        cell.detailTextLabel.text = [userSaleData actualHistory];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Fiili";
        cell.detailTextLabel.text = [userSaleData actualCurrent];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Bütçe";
        cell.detailTextLabel.text = [userSaleData budget];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gelişme";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[userSaleData development]];
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Gerçekleşme Oranı";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%%%@",[userSaleData currentRate]];
        [[cell textLabel] setTextColor:[UIColor redColor]];
        [[cell detailTextLabel] setTextColor:[UIColor redColor]];
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    sayac++;
    if (sayac == indexPath.row) {
        cell.textLabel.text = @"Kalan Litre";
        cell.detailTextLabel.text = [userSaleData leftAmount];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
        
        if(cell.detailTextLabel.text == nil)
            [cell.detailTextLabel setText:@"0"];
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    @try {
        return userSaleData.label;
    }
    @catch (NSException *exception) {
        NSLog(@"table viewda neler oluyor?");
        return @"My Title";
    }
    @finally {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)itemBasedSalesGraph {
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_ITEM_SALES_DATA"];
    
    [sapHandler addImportWithKey:@"I_MYK" andValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
    
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:beginDate];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:endDate];
    [sapHandler addImportWithKey:@"I_MATNR" andValue:[userSaleData lineKey]];
    
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithObjects:@"AY", @"LITRE", @"BUTCE", nil];
    NSMutableArray *arr3 = [[NSMutableArray alloc] initWithObjects:@"TYPE", @"ID", @"NUMBER", @"MESSAGE", @"LOG_NO", @"LOG_MSG_NO", @"MESSAGE_V1", @"MESSAGE_V2", @"MESSAGE_V3", @"MESSAGE_V4", @"PARAMETER", @"ROW", @"FIELD", @"SYSTEM", nil];
    NSMutableArray *arr4 = [[NSMutableArray alloc] initWithObjects:@"TABLO1_GOSTER", @"TABLO2_GOSTER", @"TABLO3_GOSTER", @"TABLO4_GOSTER", @"TABLO1_BASLIK", @"TABLO2_BASLIK", @"TABLO4_BASLIK", nil];
    
    [sapHandler addTableWithName:@"TABLO1" andColumns:arr2];
    [sapHandler addTableWithName:@"TABLO2" andColumns:arr2];
    [sapHandler addTableWithName:@"TABLO3" andColumns:arr2];
    [sapHandler addTableWithName:@"RETURN" andColumns:arr3];
    [sapHandler addTableWithName:@"EKBILGI" andColumns:arr4];
    [sapHandler addImportWithKey:@"I_NEW" andValue:@"X"];
    
    [sapHandler prepCall];
    //[activityIndicator startAnimating];
    [super playAnimationOnView:self.view];
    
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    
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
    
    [self showItemBasedSalesChart];
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

- (void)showItemBasedSalesChart {
    MAViewController *mv = [[MAViewController alloc] init];
    
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
    
    mv.title = @"Efes Satışlarım";
    mv.metaDataPath = [[NSBundle mainBundle] pathForResource:@"SalesMetadata" ofType:@"xml"];
    mv.theme = [[MAKitTheme_WelterWeight alloc] init];
    mv.dataSource = query;
    [mv.navigationItem setTitleView:nil];
    [[self navigationController] pushViewController:mv animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    table.backgroundColor = [UIColor clearColor];
    table.opaque = NO;
    table.backgroundView = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationItem] setTitle:title];
    
    if ([[userSaleData categroy] isEqualToString:@"Markalar"]) {
        UIBarButtonItem *graphButton = [[UIBarButtonItem alloc] initWithTitle:@"Grafik" style:UIBarButtonItemStyleBordered target:self action:@selector(itemBasedSalesGraph)];
        [[self navigationItem] setRightBarButtonItem:graphButton];
        
    }
    //[myTableView reloadData];
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
