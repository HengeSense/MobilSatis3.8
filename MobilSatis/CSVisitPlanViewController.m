//
//  CSVisitPlanViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 26.06.2013.
//
//

#import "CSVisitPlanViewController.h"

@interface CSVisitPlanViewController ()

@end

@implementation CSVisitPlanViewController
@synthesize tableView;
@synthesize activePickerView,button;

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
        nibName = @"CSVisitPlanViewController_Ipad";
    }else{
        nibName = @"CSVisitPlanViewController";
    }
    
    
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    userMyk = myUser;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [[self navigationItem] setTitle:@"Ziyaret Planı"];
    
    [self allocateObjects];
    
    [activePickerView setHidden:YES];
    [activePickerView setDelegate:self];
    
    [button setHidden:YES];
    
    [self getVisitPlanParameters];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Listele" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonClicked)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hidePicker:(id)sender{
    [activePickerView setHidden:YES];
    [button setHidden:YES];
    [[[self navigationItem] rightBarButtonItem] setTitle:@"Listele"];
}

- (void)allocateObjects{
    
    mudurPickerList = [[NSMutableArray alloc] init];
    bayiPickerList = [[NSMutableArray alloc] init];
    orgPickerList = [[NSMutableArray alloc] init];
    mustturPickerList = [[NSMutableArray alloc] init];
    mustgrpPickerList = [[NSMutableArray alloc] init];
    mustozlPickerList = [[NSMutableArray alloc] init];
    litrePickerList = [[NSMutableArray alloc] init];
    
}

- (void)doneButtonClicked
{
    if ([activePickerView isHidden]){
        
        //        if ([bayiRow isEqualToString:@"Seçiniz..."] ||
        //            [mustgrpRow isEqualToString:@"Seçiniz..."] ||
        //            [mustozlRow isEqualToString:@"Seçiniz..."] ||
        //            [mustturRow isEqualToString:@"Seçiniz..."] ||
        //            [orgRow isEqualToString:@"Seçiniz..."])
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"'Seçiniz...' kabul edilemez" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        //
        //            [alert show];
        //            return;
        //        }
        
        if (mdr == NULL || [mdr isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Müdürlük seçilmesi zorunludur!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        else if (bayi == NULL || [bayi isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Bayi/Distribütör seçilmesi zorunludur!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
            
        }else{
            CSPartnersForVisitViewController *partnersForVisit = [[CSPartnersForVisitViewController alloc] initWithDist:bayi anOrg:org anMusttur:musttur anMustgrp:mustgrp anMustozl:mustozl anLitre:litre                                   anMyk:userMyk.username];
            
            [[self navigationController] pushViewController:partnersForVisit animated:YES];
        }
        
    }else{
        //        if ([bayiRow isEqualToString:@"Seçiniz..."] || [orgRow isEqualToString:@"Seçiniz..."] ||
        //             [mustturRow isEqualToString:@"Seçiniz..."] || [mustozlRow isEqualToString:@"Seçiniz..."] ||
        //             [litreRow isEqualToString:@"Seçiniz..."])
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@" ' " delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        //
        //            [alert show];
        //            return;
        //
        //        }
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Listele"];
        
        switch (activePickerView.tag) {
            case 1:
                [self getVisitPlanParameters];
                break;
            case 2:
                [self getVisitPlanParameters];
                break;
            default:
                break;
        }
        
        
        
        [activePickerView setHidden:YES];
        [button setHidden:YES];
        [activePickerView reloadAllComponents];
        [tableView reloadData];
        [activePickerView selectRow:0 inComponent:0 animated:YES];
    }
}

- (void)changeButtonAction
{
    //pickerview açıksa buton ismi değişiyo
    [[[self navigationItem] rightBarButtonItem] setTitle:@"Seç"];
}

- (void)getVisitPlanParameters{
    [super playAnimationOnView:self.view];
    NSString *tableMudur   = [NSString stringWithFormat:@"T_MUDURLUK"];
    NSString *tableBayi    = [NSString stringWithFormat:@"T_BAYIDIST"];
    NSString *tableOrg     = [NSString stringWithFormat:@"T_ORG"];
    NSString *tableMusttur = [NSString stringWithFormat:@"T_MUSTTUR"];
    NSString *tableMustozl = [NSString stringWithFormat:@"T_MUSTOZL"];
    NSString *tableMustgrp = [NSString stringWithFormat:@"T_MUSTGRP"];
    NSString *tableLitre   = [NSString stringWithFormat:@"T_LITRE"];
    
    NSMutableArray *columnsMudur    = [[NSMutableArray alloc] init];
    NSMutableArray *columnsBayi    = [[NSMutableArray alloc] init];
    NSMutableArray *columnsOrg     = [[NSMutableArray alloc] init];
    NSMutableArray *columnsMusttur = [[NSMutableArray alloc] init];
    NSMutableArray *columnsMustozl = [[NSMutableArray alloc] init];
    NSMutableArray *columnsMustgrp = [[NSMutableArray alloc] init];
    NSMutableArray *columnsLitre   = [[NSMutableArray alloc] init];
    
    [columnsMudur addObject:@"SALES_OFFICE"];
    [columnsMudur addObject:@"STEXT"];
    
    [columnsBayi addObject:@"PARTNER"];
    [columnsBayi addObject:@"NAME_ORG1"];
    
    [columnsOrg addObject:@"PARTNER"];
    [columnsOrg addObject:@"NAME_ORG1"];
    
    [columnsMustozl addObject:@"ATTRIBUTE"];
    [columnsMustozl addObject:@"TEXT"];
    
    [columnsLitre addObject:@"COUNTER"];
    [columnsLitre addObject:@"LITRE"];
    
    [columnsMusttur addObject:@"KEYNO"];
    [columnsMusttur addObject:@"TEXT"];
    
    //    [columnsMustgrp addObject:@""];
    //    [columnsMustgrp addObject:@""];
    
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_SET_VISIT_PLAN"];
    [sapHandler addImportWithKey:@"I_PARTNER" andValue:userMyk.username];
    if ([mudurPickerList count] > 0) {
        [sapHandler addImportWithKey:@"I_MUDUR" andValue:mdr];
    }
    if ([bayiPickerList count] > 0) {
        [sapHandler addImportWithKey:@"I_BAYI" andValue:bayi];
    }
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tableMudur andColumns:columnsMudur];
    [sapHandler addTableWithName:tableBayi andColumns:columnsBayi];
    [sapHandler addTableWithName:tableOrg  andColumns:columnsOrg];
    [sapHandler addTableWithName:tableMusttur andColumns:columnsMusttur];
    [sapHandler addTableWithName:tableMustozl andColumns:columnsMustozl];
    //    [sapHandler addTableWithName:tableMustgrp andColumns:columnsMustgrp];
    [sapHandler addTableWithName:tableLitre   andColumns:columnsLitre];
    [sapHandler prepCall];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    //    [mudurPickerList removeAllObjects];
    [bayiPickerList removeAllObjects];
    [orgPickerList removeAllObjects];
    [mustturPickerList removeAllObjects];
    [mustozlPickerList removeAllObjects];
    [litrePickerList removeAllObjects];
    
    NSMutableArray *mudur   = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_MUDURLUK" fromEnvelope:myResponse];
    NSMutableArray *bayi    = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_BAYIDIST" fromEnvelope:myResponse];
    NSMutableArray *org     = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_ORG"  fromEnvelope:myResponse];
    NSMutableArray *musttur = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_MUSTTUR" fromEnvelope:myResponse];
    NSMutableArray *mustozl = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_MUSTOZL" fromEnvelope:myResponse];
    NSMutableArray *mustgrp = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_MUSTGRP" fromEnvelope:myResponse];
    NSMutableArray *litre   = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_LITRE" fromEnvelope:myResponse];
    
    NSMutableArray *mudurId = [[NSMutableArray alloc] init];
    NSMutableArray *mudurName = [[NSMutableArray alloc] init];
    
    NSMutableArray *bayiId = [[NSMutableArray alloc] init];
    NSMutableArray *bayiName = [[NSMutableArray alloc] init];
    
    NSMutableArray *orgId = [[NSMutableArray alloc] init];
    NSMutableArray *orgName = [[NSMutableArray alloc] init];
    
    NSMutableArray *mustturId = [[NSMutableArray alloc] init];
    NSMutableArray *mustturText = [[NSMutableArray alloc] init];
    
    NSMutableArray *mustozlId = [[NSMutableArray alloc] init];
    NSMutableArray *mustozlText = [[NSMutableArray alloc] init];
    
    NSMutableArray *mustgrpId = [[NSMutableArray alloc] init];
    NSMutableArray *mustgrpText = [[NSMutableArray alloc] init];
    
    NSMutableArray *litreId = [[NSMutableArray alloc] init];
    NSMutableArray *litreText = [[NSMutableArray alloc] init];
    
    mudurId = [ABHXMLHelper getValuesWithTag:@"SALES_OFFICE" fromEnvelope:[mudur objectAtIndex:0]];
    mudurName = [ABHXMLHelper getValuesWithTag:@"STEXT" fromEnvelope:[mudur objectAtIndex:0]];
    
    bayiId = [ABHXMLHelper getValuesWithTag:@"PARTNER" fromEnvelope:[bayi objectAtIndex:0]];
    bayiName = [ABHXMLHelper getValuesWithTag:@"NAME_ORG1" fromEnvelope:[bayi objectAtIndex:0]];
    
    orgId = [ABHXMLHelper getValuesWithTag:@"PARTNER" fromEnvelope:[org objectAtIndex:0]];
    orgName = [ABHXMLHelper getValuesWithTag:@"NAME_ORG1" fromEnvelope:[org objectAtIndex:0]];
    
    mustturId   = [ABHXMLHelper getValuesWithTag:@"KEYNO" fromEnvelope:[musttur objectAtIndex:0]];
    mustturText = [ABHXMLHelper getValuesWithTag:@"TEXT" fromEnvelope:[musttur objectAtIndex:0]];
    
    mustozlId = [ABHXMLHelper getValuesWithTag:@"ATTRIBUTE" fromEnvelope:[mustozl objectAtIndex:0]];
    mustozlText = [ABHXMLHelper getValuesWithTag:@"TEXT" fromEnvelope:[mustozl objectAtIndex:0]];
    
    //    mustgrpId = [ABHXMLHelper getValuesWithTag:@"PARTNER" fromEnvelope:[mustgrp objectAtIndex:0]];
    //    mustgrpId = [ABHXMLHelper getValuesWithTag:@"TEXT" fromEnvelope:[mustgrp objectAtIndex:0]];
    
    litreId = [ABHXMLHelper getValuesWithTag:@"COUNTER" fromEnvelope:[litre objectAtIndex:0]];
    litreText = [ABHXMLHelper getValuesWithTag:@"LITRE" fromEnvelope:[litre objectAtIndex:0]];
    
    for (int sayac = 0; sayac<[mudurId count]; sayac++) {
        NSString *mudurluk        = [mudurId objectAtIndex:sayac];
        NSString *mudurlukDesc    = [mudurName objectAtIndex:sayac];
        NSArray  *mudurArr = [NSArray arrayWithObjects:mudurluk,mudurlukDesc, nil];
        
        [mudurPickerList addObject:mudurArr];
    }
    
    for (int sayac = 0; sayac<[bayiId count]; sayac++) {
        NSString *bayidist        = [bayiId objectAtIndex:sayac];
        NSString *bayiDescription = [bayiName objectAtIndex:sayac];
        NSArray *bayiArr = [NSArray arrayWithObjects:bayidist,bayiDescription, nil];
        
        [bayiPickerList addObject:bayiArr];
    }
    
    for (int sayac = 0; sayac<[orgId count]; sayac++) {
        NSString *org = [orgId objectAtIndex:sayac];
        NSString *orgDescription = [orgName objectAtIndex:sayac];
        NSArray *orgArr = [NSArray arrayWithObjects:org,orgDescription, nil];
        
        [orgPickerList addObject:orgArr];
    }
    
    for (int sayac = 0; sayac<[mustturId count]; sayac++) {
        NSString *musttur = [mustturId objectAtIndex:sayac];
        NSString *mustturDesc = [mustturText objectAtIndex:sayac];
        NSArray *mustturArr = [NSArray arrayWithObjects:musttur,mustturDesc, nil];
        
        [mustturPickerList addObject:mustturArr];
    }
    
    for (int sayac = 0; sayac<[mustozlId count]; sayac++) {
        NSString *mustozl = [mustozlId objectAtIndex:sayac];
        NSString *mustozlDesc = [mustozlText objectAtIndex:sayac];
        NSArray *mustozlArr = [NSArray arrayWithObjects:mustozl,mustozlDesc, nil];
        
        [mustozlPickerList addObject:mustozlArr];
    }
    
    for (int sayac = 0; sayac<[mustgrpId count]; sayac++) {
        NSString *mustgrp = [mustgrpId objectAtIndex:sayac];
        NSString *mustgrpDesc = [mustgrpText objectAtIndex:sayac];
        NSArray *mustgrpArr = [NSArray arrayWithObjects:mustgrp,mustgrpDesc, nil];
        
        [mustgrpPickerList addObject:mustgrpArr];
    }
    
    for (int sayac = 0; sayac<[litreId count]; sayac++) {
        NSString *litre = [litreId objectAtIndex:sayac];
        NSString *litreDesc = [litreText objectAtIndex:sayac];
        NSArray *litreArr = [NSArray arrayWithObjects:litre,litreDesc, nil];
        
        [litrePickerList addObject:litreArr];
    }
    
    [super stopAnimationOnView];
    
}

#pragma mark - Table Delegation Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
    //    return 6;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    switch (indexPath.row) {
        case 0:
            [[cell textLabel]setText:@"Müdürlük"];
            [[cell detailTextLabel]setText:mdrRow];
            break;
        case 1:
            [[cell textLabel]setText:@"Bayi/Distribütör"];
            [[cell detailTextLabel]setText:bayiRow];
            break;
        case 2:
            [[cell textLabel]setText:@"Organizasyon"];
            [[cell detailTextLabel]setText:orgRow];
            break;
        case 3:
            [[cell textLabel]setText:@"Müşteri Türü"];
            [[cell detailTextLabel]setText:mustturRow];
            break;
        case 4:
            [[cell textLabel]setText:@"Müşteri Özelliği"];
            [[cell detailTextLabel]setText:mustozlRow];
            break;
        case 5:
            [[cell textLabel]setText:@"Litre Aralığı"];
            [[cell detailTextLabel]setText:litreRow];
            break;
            
            //        case 3:
            //            [[cell textLabel]setText:@"Müşteri Grubu"];
            //            [[cell detailTextLabel]setText:mustgrpRow];
            //            break;
            //        case 4:
            //            [[cell textLabel]setText:@"Müşteri Özelliği"];
            //            [[cell detailTextLabel]setText:mustozlRow];
            //            break;
            //        case 5:
            //            [[cell textLabel]setText:@"Litre Aralığı"];
            //            [[cell detailTextLabel]setText:litreRow];
            //            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self changeButtonAction];
    [button setHidden:NO];
    switch ([indexPath row]) {
        case 0:
            [activePickerView setTag:1];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
        case 1:
            [activePickerView setTag:2];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
        case 2:
            [activePickerView setTag:3];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
        case 3:
            [activePickerView setTag:4];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
        case 4:
            [activePickerView setTag:5];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
        case 5:
            [activePickerView setTag:6];
            [activePickerView setHidden:NO];
            [activePickerView reloadAllComponents];
            break;
            //        case 5:
            //            [activePickerView setTag:6];
            //            [activePickerView setHidden:NO];
            //            [activePickerView reloadAllComponents];
            //            break;
        default:
            break;
    }
    
    return;
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    CSSalesRepresentative *selectedCustomer = [salesRepresentative objectAtIndex:indexPath.row];
//
//    CSDetailSalesRepresentativeViewController *detailSalesRepresentative;
//
//    detailSalesRepresentative = [[CSDetailSalesRepresentativeViewController alloc] initWithArray:customerItemTable anSelectedCustomer:selectedCustomer];
//
//    [[self navigationController] pushViewController:detailSalesRepresentative animated:YES];
//}

#pragma mark - Pickerview Delegation Methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch ([pickerView tag]) {
        case 1:
            return [mudurPickerList count];
            break;
        case 2:
            return [bayiPickerList count];
            break;
        case 3:
            return [orgPickerList count];
            break;
        case 4:
            return [mustturPickerList count];
            break;
            //        case 4:
            //            return [mustgrpPickerList count];
            //            break;
        case 5:
            return [mustozlPickerList count];
            break;
        case 6:
            return [litrePickerList count];
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch ([pickerView tag]) {
        case 1:
            return [[mudurPickerList objectAtIndex:row] objectAtIndex:1];
            break;
        case 2:
            return [[bayiPickerList objectAtIndex:row] objectAtIndex:1];
            break;
        case 3:
            return [[orgPickerList objectAtIndex:row] objectAtIndex:1];
            break;
        case 4:
            return [[mustturPickerList objectAtIndex:row] objectAtIndex:1];
            break;
            //        case 4:
            //            return [[mustgrpPickerList objectAtIndex:row] objectAtIndex:1];
            //            break;
        case 5:
            return [[mustozlPickerList objectAtIndex:row] objectAtIndex:1];
            break;
        case 6:
            return [[litrePickerList objectAtIndex:row] objectAtIndex:1];
            break;
        default:
            break;
    }
    
    return @"";
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        return 650;
    }
    else {
        return 300;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch ([pickerView tag]) {
        case 1:
            mdr    = [[mudurPickerList objectAtIndex:row] objectAtIndex:0];
            mdrRow = [[mudurPickerList objectAtIndex:row] objectAtIndex:1];
            if ([mdrRow isEqualToString:@"Seçiniz..."]) {
                mdr = @"";
                mdrRow = @"";
            }
            
            bayiRow = @"";
            orgRow = @"";
            break;
        case 2:
            bayi    = [[bayiPickerList objectAtIndex:row] objectAtIndex:0];
            bayiRow = [[bayiPickerList objectAtIndex:row] objectAtIndex:1];
            if ([bayiRow isEqualToString:@"Seçiniz..."]) {
                bayi = @"";
                bayiRow = @"";
            }
            orgRow = @"";
            break;
        case 3:
            org    =  [[orgPickerList objectAtIndex:row] objectAtIndex:0];
            orgRow =  [[orgPickerList objectAtIndex:row] objectAtIndex:1];
            if ([orgRow isEqualToString:@"Seçiniz..."]) {
                org = @"";
                orgRow = @"";
            }
            break;
        case 4:
            musttur    =  [[mustturPickerList objectAtIndex:row] objectAtIndex:0];
            mustturRow =  [[mustturPickerList objectAtIndex:row] objectAtIndex:1];
            if ([mustturRow isEqualToString:@"Seçiniz..."]) {
                musttur = @"";
                mustturRow= @"";
            }
            break;
            //        case 4:
            //            mustgrp    =  [[mustgrpPickerList objectAtIndex:row] objectAtIndex:0];
            //            mustgrpRow =  [[mustgrpPickerList objectAtIndex:row] objectAtIndex:1];
            //            break;
        case 5:
            mustozl    =  [[mustozlPickerList objectAtIndex:row] objectAtIndex:0];
            mustozlRow =  [[mustozlPickerList objectAtIndex:row] objectAtIndex:1];
            if ([mustozlRow isEqualToString:@"Seçiniz..."]) {
                mustozl = @"";
                mustozlRow = @"";
            }
            break;
        case 6:
            litre    = [[litrePickerList objectAtIndex:row] objectAtIndex:0];
            litreRow = [[litrePickerList objectAtIndex:row] objectAtIndex:1];
            if ([litreRow isEqualToString:@"Seçiniz..."]) {
                litre = @"";
                litreRow = @"";
            }
            break;
        default:
            break;
    }
}

@end
