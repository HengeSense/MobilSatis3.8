//
//  CSPartnersForVisitViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 28.06.2013.
//
//

#import "CSPartnersForVisitViewController.h"

@interface CSPartnersForVisitViewController ()

@end
@implementation CSPartnersForVisitViewController
@synthesize tableView,myPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDist:(NSString *)bayi anOrg:(NSString *)org anMusttur:(NSString *)musttur anMustgrp:(NSString *)mustgrp anMustozl:(NSString *)mustozl anLitre:(NSString *)litre anMyk:(NSString *)myk
{
    NSString *nibName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        nibName = @"CSPartnersForVisitViewController_Ipad";
    }else{
        nibName = @"CSPartnersForVisitViewController";
    }
    
    self = [super initWithNibName:nibName bundle:nil];
    
    partners = [[CSVisitPartners alloc] init];
    
    [partners setBayiId:bayi];
    [partners setOrgId:org];
    [partners setMustgrpId:mustgrp];
    [partners setMustozlId:mustozl];
    [partners setMustturId:musttur];
    [partners setLitreId:litre];
    [partners setMyk:myk];
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    
    [myPicker setHidden:YES];
    
    [self setPickerViewRowPosition];
    selectedIndex = [[NSMutableArray alloc] init];
    
    //    [tableView setDelegate:self];
    
    [[self navigationItem]setTitle:@"Müşteri Seçimi"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Tarih Seç" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseVisitBeginDate)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    [self getPartnersForVisit:partners];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPickerViewRowPosition
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    int month = [components month];
    int day   = [components day];
    [myPicker selectRow:day-1 inComponent:0 animated:NO];
    [myPicker selectRow:month-1 inComponent:1 animated:NO];
    [myPicker selectRow:day-1 inComponent:2 animated:NO];
    [myPicker selectRow:month-1 inComponent:3 animated:NO];
}

- (void)chooseVisitBeginDate{
    [myPicker setHidden:NO];
    [myPicker setDelegate:self];
    //    [tableView setHidden:YES];
    [[self navigationItem]setTitle:@"Başlangıç/Bitiş Tarihi"];
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Ziyaret Planı Yarat" style:UIBarButtonItemStyleBordered target:self action:@selector(createVisitPlanConfirmation)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}

- (void)createVisitPlanConfirmation{
    [self convertStringToBeginDate:myPicker];
    [self convertStringToEndDate:myPicker];
    
//    int dayDiff = [myPicker selectedRowInComponent:2] -[myPicker selectedRowInComponent:0];
    NSDate   *begda = [[NSDate alloc]init];
    NSDate   *endda = [[NSDate alloc] init];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyyMMdd"];
    begda = [dateFormat dateFromString:[partners beginDate]];
    endda   = [dateFormat dateFromString:[partners endDate]];
    
    NSTimeInterval interval = [endda timeIntervalSinceDate:begda];
    int dayDiff = interval / 86400;

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSComparisonResult *result = [[partners endDate] compare:[partners beginDate]];
    if (result == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Başlangıç tarihi bitiş tarihinden büyük olamaz!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [self setPickerViewRowPosition];
        [alert show];
        return;
    }
    
    else if ([myPicker selectedRowInComponent:0]+1 < [components day] || [myPicker selectedRowInComponent:1]+1 < [components month])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Geçmişe yönelik ziyaret yaratılamaz!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [self setPickerViewRowPosition];
        [alert show];
        return;
    }
//    else if ([myPicker selectedRowInComponent:3] != [myPicker selectedRowInComponent:1])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Ziyaret planı aynı ay içinde yaratılabilir!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
//        
//        [self setPickerViewRowPosition];
//        [alert show];
//        return;
//    }
    
    else if (dayDiff > 7)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Ziyaret plan aralığı 1 haftadan fazla olamaz!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [self setPickerViewRowPosition];
        [alert show];
        return;
    }
    else{
        
        [[self navigationItem]setTitle:@"Müşteri Seçimi"];
        //    [myPicker setHidden:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Ziyaret planı yaratılacaktır, emin misiniz?" delegate:self cancelButtonTitle:@"Evet" otherButtonTitles:@"Hayır",nil];
        
        alert.tag = 1;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0) {
                [self createVisitPlan:partners];
            }else{
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Ziyaret Planı Yarat" style:UIBarButtonItemStyleBordered target:self action:@selector(createVisitPlanConfirmation)];
                [[self navigationItem] setRightBarButtonItem:doneButton];
            }
            break;
            
        case 2:
            if (buttonIndex == 0) {
                [[self navigationController] popViewControllerAnimated:YES];
            }
            break;
        case 3:
            if (buttonIndex == 0) {
                [[self navigationController] popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }
}

-(void)convertStringToBeginDate:(UIPickerView*)pickerView{
    int beginDay = [pickerView selectedRowInComponent:0]+1;
    int beginMonth = [pickerView selectedRowInComponent:1]+1;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *day = [[NSString alloc] init];
    NSString *month = [[NSString alloc] init];
    NSDate   *beginDate = [[NSDate alloc]init];
    
    if (beginDay < 10){
        
        day = [NSString stringWithFormat:@"%@%d",@"0",beginDay];
    }
    else
    {
        day = [NSString stringWithFormat:@"%d",beginDay];
    }
    
    
    if (beginMonth < 10){
        
        month = [NSString stringWithFormat:@"%@%d",@"0",beginMonth];
    }
    else
    {
        month = [NSString stringWithFormat:@"%d",beginMonth];
    }
    
    NSString *date = [NSString stringWithFormat:@"%d%@%@",[components year],month,day];
    //    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //
    //    [dateFormat setDateFormat:@"ddMMyyyy"];
    //    beginDate = [dateFormat dateFromString:date];
    [partners setBeginDate:date];
}

-(void)convertStringToEndDate:(UIPickerView*)pickerView{
    int endDay = [pickerView selectedRowInComponent:2]+1;
    int endMonth = [pickerView selectedRowInComponent:3]+1;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *day = [[NSString alloc] init];
    NSString *month = [[NSString alloc] init];
    NSDate   *endDate = [[NSDate alloc] init];
    
    if (endDay < 10){
        
        day = [NSString stringWithFormat:@"%@%d",@"0",endDay];
    }
    else
    {
        day = [NSString stringWithFormat:@"%d",endDay];
    }
    
    
    if (endMonth < 10){
        
        month = [NSString stringWithFormat:@"%@%d",@"0",endMonth];
    }
    else
    {
        month = [NSString stringWithFormat:@"%d",endMonth];
    }
    
    NSString *date = [NSString stringWithFormat:@"%d%@%@",[components year],month,day];
    //    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"ddMMyyyy"];
    //
    //    endDate = [dateFormat dateFromString:date];
    [partners setEndDate:date];
    
}

- (void)createVisitPlan:(CSVisitPartners *)partners{
    [super playAnimationOnView:self.view];
    
    if ([selectedIndex count] > 0) {
    
    for (int j = 0; j < [selectedIndex count]; j++)
    {
        
        for (int i = 0; i < 1 ; i++)
        {
            
            int index;
            index= [[selectedIndex objectAtIndex:j] intValue];
            
            if (partnerSplit == nil) {
                partnerSplit = [NSString stringWithFormat:@"%@",[[partnerForVisit objectAtIndex:index] objectAtIndex:0]];
            }
            else{
                partnerSplit = [NSString stringWithFormat:@"%@%@%@",partnerSplit,@"*",[[partnerForVisit objectAtIndex:index] objectAtIndex:0]];
            }
        }
    }
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CREATE_VISIT_PLAN"];
    
    [sapHandler addImportWithKey:@"I_PARTNER" andValue:partnerSplit];
    [sapHandler addImportWithKey:@"I_MYK" andValue:[partners myk]];
    [sapHandler addImportWithKey:@"I_MOBIL" andValue:@"X"];
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:[partners beginDate]];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:[partners endDate]];
    
    [sapHandler setDelegate:self];
    [sapHandler prepCall];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"En az bir nokta seçmelisiniz" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
}

- (void)getPartnersForVisit:(CSVisitPartners *)partners{
    [super playAnimationOnView:self.view];
    NSString *tablePartners    = [NSString stringWithFormat:@"T_PARTNER_LIST"];
    
    NSMutableArray *columnsPartners    = [[NSMutableArray alloc] init];
    
    [columnsPartners addObject:@"PARTNER"];
    [columnsPartners addObject:@"NAME_ORG1"];
    [columnsPartners addObject:@"SALES_LITRE"];
    [columnsPartners addObject:@"VISIT_COUNT"];
    [columnsPartners addObject:@"LAST_VISIT_DATE"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    
    if ([partners orgId] == NULL) {
        [partners setOrgId:@""];
    }
    if ([partners mustturId] == NULL){
        [partners setMustturId:@""];
    }
    if ([partners mustgrpId] == NULL){
        [partners setMustgrpId:@""];
    }
    if ([partners mustozlId] == NULL){
        [partners setMustozlId:@""];
    }
    if ([partners litreId] == NULL) {
        [partners setLitreId:@""];
    }
    
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_PARTNERS_FOR_VISIT"];
    [sapHandler addImportWithKey:@"I_DIST" andValue:[partners bayiId]];
    [sapHandler addImportWithKey:@"I_ORG" andValue:[partners orgId]];
    [sapHandler addImportWithKey:@"I_CUST_TYPE" andValue:[partners mustturId]];
    [sapHandler addImportWithKey:@"I_CUST_GROUP" andValue:[partners mustgrpId]];
    [sapHandler addImportWithKey:@"I_CUST_ATTR" andValue:[partners mustozlId]];
    [sapHandler addImportWithKey:@"I_CUST_LITRE" andValue:partners.litreId];
    [sapHandler addImportWithKey:@"I_MYK" andValue:[partners myk]];
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tablePartners andColumns:columnsPartners];
    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_CREATE_VISIT_PLAN"
                                options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        [super stopAnimationOnView];
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
        
        if ([[responses objectAtIndex:0] isEqualToString: @"T"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Ziyaret planı başarıyla yaratıldı" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
            return;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Ziyaret planı yaratılamadı lütfen tekrar deneyiniz" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
    }
    else
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_PARTNER_LIST" fromEnvelope:myResponse];
        
        NSRange range = [myResponse rangeOfString:@"item"];
        if (range.length > 0)
        {
            partnerForVisit = [[NSMutableArray alloc] init];
            NSMutableArray *partners = [[NSMutableArray alloc] init];
            NSMutableArray *name_org1 = [[NSMutableArray alloc] init];
            NSMutableArray *salesLitre = [[NSMutableArray alloc] init];
            NSMutableArray *visitCount = [[NSMutableArray alloc] init];
            NSMutableArray *lastVisit = [[NSMutableArray alloc] init];
            
            partners = [ABHXMLHelper getValuesWithTag:@"PARTNER" fromEnvelope:[responses objectAtIndex:0]];
            name_org1 = [ABHXMLHelper getValuesWithTag:@"NAME_ORG1" fromEnvelope:[responses objectAtIndex:0]];
            salesLitre = [ABHXMLHelper getValuesWithTag:@"SALES_LITRE" fromEnvelope:[responses objectAtIndex:0]];
            visitCount = [ABHXMLHelper getValuesWithTag:@"VISIT_COUNT" fromEnvelope:[responses objectAtIndex:0]];
            lastVisit = [ABHXMLHelper getValuesWithTag:@"LAST_VISIT_DATE" fromEnvelope:[responses objectAtIndex:0]];
            
            if ([partners count] > 0) {
                
                for (int sayac = 0; sayac<[partners count]; sayac++) {
                    
                    NSString *partner     = [partners objectAtIndex:sayac];
                    NSString *partnerName = [name_org1 objectAtIndex:sayac];
                    NSString *sales       = [salesLitre objectAtIndex:sayac];
                    NSString *visit       = [visitCount objectAtIndex:sayac];
                    NSString *visitDate   = [lastVisit objectAtIndex:sayac];
                    
                    NSArray  *partnerArr = [NSArray arrayWithObjects:partner,partnerName,sales,visit,visitDate, nil];
                    
                    [partnerForVisit addObject:partnerArr];
                }
                [super stopAnimationOnView];
                [tableView reloadData];
            }
            else
            {
                [super stopAnimationOnView];
            }
            
        }
        else
        {
            [super stopAnimationOnView];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Seçmiş olduğunuz kriterlere uygun veri bulunamamıştır!" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            alert.tag = 3;
            [alert show];
            return;
        }
    }
}


#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [partnerForVisit count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [[cell textLabel]setText:[[partnerForVisit objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    for (int i = 0; i < selectedIndex.count; i++) {
        NSUInteger num = [[selectedIndex objectAtIndex:i] intValue];
        
        if (num == indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
        
    }
    NSString *detailText = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"Satış Litresi: ",[[partnerForVisit objectAtIndex:indexPath.row] objectAtIndex:2],@" ",@"Ziyaret Adedi: ",[[partnerForVisit objectAtIndex:indexPath.row] objectAtIndex:3],@" ",@"Son Ziyaret: ",[[partnerForVisit objectAtIndex:indexPath.row] objectAtIndex:4]];
    
    [[cell detailTextLabel] setText:detailText];
    
    [[cell  detailTextLabel]setFont:[UIFont systemFontOfSize:10]];
    
    //    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    //    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone) {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [selectedIndex addObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [selectedIndex removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //    if (![super isAnimationRunning]) {
    //        if (section == 0 && [[self navigationItem] rightBarButtonItem] != nil) {
    //            [[[self navigationItem] rightBarButtonItem] setTitle:@"Değiştir"];
    //            [[self pickerView] setHidden:YES];
    //        }
    //        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[salesRepresentative objectAtIndex:indexPath.row] locationCoordinate] coordinate], 100, 100);
    //
    //        [mapView setRegion:region animated:YES];
    //    }
}
#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return 31;
            break;
        case 1:
            return 12;
            break;
        case 2:
            return 31;
            break;
        case 3:
            return 12;
            break;
        default:
            break;
    }
    return 31;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [CSApplicationHelper getDaysFromNumber:row];
            break;
        case 1:
            return [CSApplicationHelper getMonthFromNumber:row];
            break;
        case 2:
            return [CSApplicationHelper getDaysFromNumber:row];
            break;
        case 3:
            return [CSApplicationHelper getMonthFromNumber:row];
            break;
        default:
            break;
    }
    return [CSApplicationHelper getDaysFromNumber:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    switch (component){
        case 0:
            return 40.0f;
        case 1:
            return 100.0f;
        case 2:
            return 40.0f;
        case 3:
            return 100.0f;
    }
    return 0;
}

- (BOOL)checkMonths{
    NSDate *date;
    UIAlertView *alert;
    if ([myPicker selectedRowInComponent:0] > [myPicker selectedRowInComponent:1]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Başlangıç ayı bitiş ayından küçük olamaz" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }else{
        date = [NSDate date];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        if ([myPicker selectedRowInComponent:1] +1  > components.month) {
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Son ay mevcut aydan büyük olamaz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
            return NO;
            
        }
        return YES;
    }
}

@end
