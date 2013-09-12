//
//  CSExpenseReportViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 03.07.2013.
//
//

#import "CSExpenseReportViewController.h"

@interface CSExpenseReportViewController ()

@end

@implementation CSExpenseReportViewController
@synthesize tableView,myPicker;

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
        nibName = @"CSExpenseReportViewController_Ipad";
    }else{
        nibName = @"CSExpenseReportViewController";
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
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    
    [myPicker setHidden:NO];
    [tableView setHidden:YES];
    
    expenseReport = [[NSMutableArray alloc] init];
    currentCollective = [[NSMutableArray alloc] init];
    currentCollectiveDistinct = [[NSMutableArray alloc] init];
    lastCollective = [[NSMutableArray alloc] init];
    expenseReportMonth = [[NSMutableArray alloc] init];
    
    [self setPickerViewRowPosition];
    
    [[self navigationItem]setTitle:@"Masraf Raporu"];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Raporu Getir" style:UIBarButtonItemStyleBordered target:self action:@selector(viewExpenseReport)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setPickerViewRowPosition{
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    int month = [components month];
    [myPicker selectRow:month-2 inComponent:0 animated:YES];
    [myPicker selectRow:month-2 inComponent:1 animated:YES];
}

- (void) viewExpenseReport{
    if (![self checkMonths]) {
        return;
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Tarih Seç" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseExpenseDate)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    
    NSString *endDate = [self convertStringToEndDate:myPicker];
    NSString *beginDate = [self convertStringToBeginDate:myPicker];
    
    [self getExpenseReportFromBW:beginDate anEndDate:endDate];
    
    [tableView setHidden:NO];
    [myPicker setHidden:YES];
}

- (BOOL)checkMonths{
    NSDate *date;
    UIAlertView *alert;
    if ([myPicker selectedRowInComponent:0] > [myPicker selectedRowInComponent:1]) {
        alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Başlangıç ayı bitiş ayından büyük olamaz" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
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
        if ([myPicker selectedRowInComponent:1]+1 == components.month) {
            alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Mevcut ayın raporu alınamaz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        return YES;
    }
}		

-(NSString *)convertStringToBeginDate:(UIPickerView*)pickerView{
    int beginMonth = [pickerView selectedRowInComponent:0]+1;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *month = [[NSString alloc] init];
    NSDate   *beginDate = [[NSDate alloc]init];
    
    if (beginMonth < 10){
        
        month = [NSString stringWithFormat:@"%@%d",@"0",beginMonth];
    }
    else
    {
        month = [NSString stringWithFormat:@"%d",beginMonth];
    }
    
    //    NSString *date = [NSString stringWithFormat:@"01%@%d",month,[components year]];
    NSString *date = [NSString stringWithFormat:@"%d%@01",[components year],month];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    //    [dateFormat setDateFormat:@"ddMMyyyy"];
    //    beginDate = [dateFormat dateFromString:date];
    
    return date;
}

-(NSString *)convertStringToEndDate:(UIPickerView*)pickerView{
    int endMonth = [pickerView selectedRowInComponent:1]+1;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *month = [[NSString alloc] init];
    NSDate   *endDate = [[NSDate alloc] init];
    
    if (endMonth < 10){
        
        month = [NSString stringWithFormat:@"%@%d",@"0",endMonth];
    }
    else
    {
        month = [NSString stringWithFormat:@"%d",endMonth];
    }
    
    //    NSString *date = [NSString stringWithFormat:@"01%@%d",month,[components year]];
    //    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"ddMMyyyy"];
    NSString *date = [NSString stringWithFormat:@"%d%@01",[components year],month];
    //    endDate = [dateFormat dateFromString:date];
    
    return date;
}

- (void)chooseExpenseDate{
    [myPicker setHidden:NO];
    [tableView setHidden:YES];
    [self setPickerViewRowPosition];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Raporu Getir" style:UIBarButtonItemStyleBordered target:self action:@selector(viewExpenseReport)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}

- (void) getExpenseReportFromBW:(NSDate*)beginDate anEndDate:(NSDate*)endDate{
    [super playAnimationOnView:self.view];
    NSString *currentTable    = [NSString stringWithFormat:@"ET_CURRENT_EXPENSES"];
    NSString *lastCollTable       = [NSString stringWithFormat:@"ET_LAST_YEAR_EXPENSES"];
    NSString *currentCollTable       = [NSString stringWithFormat:@"ET_CURRENT_COLLECTIVE_EXPENSES"];
    NSString *currentDistinct      = [NSString stringWithFormat:@"ET_CURRENT_DISTINCT"];
    
    NSMutableArray *columnsPartners    = [[NSMutableArray alloc] init];
    
    [columnsPartners addObject:@"FISCPER"];
    [columnsPartners addObject:@"FISCPER3"];
    [columnsPartners addObject:@"FISCYEAR"];
    [columnsPartners addObject:@"COSTELMNT"];
    [columnsPartners addObject:@"/BIC/ZTUTAR"];
    [columnsPartners addObject:@"VTYPE"];
    [columnsPartners addObject:@"DESCRIPTION"];
    
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getR3Destination] andSystemNumber:[ABHConnectionInfo getR3SystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_EXPENSE_REPORT_FROMBW"];
    
    [sapHandler addImportWithKey:@"I_UNAME" andValue:[userMyk username]];
    [sapHandler addImportWithKey:@"I_BEGIN_DATE" andValue:beginDate];
    [sapHandler addImportWithKey:@"I_END_DATE" andValue:endDate];
    
    [sapHandler setDelegate:self];
    
    [sapHandler addTableWithName:currentTable andColumns:columnsPartners];
    [sapHandler addTableWithName:lastCollTable andColumns:columnsPartners];
    [sapHandler addTableWithName:currentCollTable andColumns:columnsPartners];
    [sapHandler addTableWithName:currentDistinct andColumns:columnsPartners];
    
    [sapHandler prepCall];
    
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    NSRange range = [myResponse rangeOfString:@"item"];
    if (range.length > 0)
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_EXPENSE_TABLE" fromEnvelope:myResponse];
        
        NSMutableArray *fiscPer    = [[NSMutableArray alloc] init];
        NSMutableArray *fiscPer3   = [[NSMutableArray alloc] init];
        NSMutableArray *fiscYear   = [[NSMutableArray alloc] init];
        NSMutableArray *costElmnt  = [[NSMutableArray alloc] init];
        NSMutableArray *tutar      = [[NSMutableArray alloc] init];
        NSMutableArray *vtype      = [[NSMutableArray alloc] init];
        
        NSMutableArray *currCollCost = [[NSMutableArray alloc] init];
        NSMutableArray *currCollTutar = [[NSMutableArray alloc] init];
        NSMutableArray *currCollVtype = [[NSMutableArray alloc] init];
        
        NSMutableArray *currDistCost = [[NSMutableArray alloc] init];
        NSMutableArray *currDistDesc = [[NSMutableArray alloc] init];
        NSMutableArray *currDistTutar = [[NSMutableArray alloc] init];
        NSMutableArray *currDistVtype = [[NSMutableArray alloc] init];
        
        NSMutableArray *lastCollCost = [[NSMutableArray alloc] init];
        NSMutableArray *lastCollTutar = [[NSMutableArray alloc] init];
        NSMutableArray *lastCollVtype = [[NSMutableArray alloc] init];
        
        
        
        
        fiscPer   = [ABHXMLHelper getValuesWithTag:@"FISCPER" fromEnvelope:[responses objectAtIndex:0]];
        fiscPer3  = [ABHXMLHelper getValuesWithTag:@"FISCPER3" fromEnvelope:[responses objectAtIndex:0]];
        fiscYear  = [ABHXMLHelper getValuesWithTag:@"FISCYEAR" fromEnvelope:[responses objectAtIndex:0]];
        costElmnt = [ABHXMLHelper getValuesWithTag:@"COSTELMNT" fromEnvelope:[responses objectAtIndex:0]];
        tutar  = [ABHXMLHelper getValuesWithTag:@"_-BIC_-ZTUTAR" fromEnvelope:[responses objectAtIndex:0]];
        vtype = [ABHXMLHelper getValuesWithTag:@"VTYPE" fromEnvelope:[responses objectAtIndex:0]];
        
        
        // Geçtiğimiz yılın kümüle değerleri
        lastCollCost = [ABHXMLHelper getValuesWithTag:@"COSTELMNT" fromEnvelope:[responses objectAtIndex:1]];
        lastCollTutar = [ABHXMLHelper getValuesWithTag:@"_-BIC_-ZTUTAR" fromEnvelope:[responses objectAtIndex:1]];
        lastCollVtype = [ABHXMLHelper getValuesWithTag:@"VTYPE" fromEnvelope:[responses objectAtIndex:1]];
        
        
        // mevcut yılın kümüle değerleri duplicate kayıtlar var
        currCollCost = [ABHXMLHelper getValuesWithTag:@"COSTELMNT" fromEnvelope:[responses objectAtIndex:2]];
        currCollTutar = [ABHXMLHelper getValuesWithTag:@"_-BIC_-ZTUTAR" fromEnvelope:[responses objectAtIndex:2]];
        currCollVtype = [ABHXMLHelper getValuesWithTag:@"VTYPE" fromEnvelope:[responses objectAtIndex:2]];
        
        //mevcut yılın kümüle değerleri duplicate kayıtlar yok
        currDistCost = [ABHXMLHelper getValuesWithTag:@"COSTELMNT" fromEnvelope:[responses objectAtIndex:3]];
        currDistDesc = [ABHXMLHelper getValuesWithTag:@"DESCRIPTION" fromEnvelope:[responses objectAtIndex:3]];
        currDistTutar = [ABHXMLHelper getValuesWithTag:@"_-BIC_-ZTUTAR" fromEnvelope:[responses objectAtIndex:3]];
        currDistVtype = [ABHXMLHelper getValuesWithTag:@"VTYPE" fromEnvelope:[responses objectAtIndex:3]];
        
        [expenseReport removeAllObjects];
        [lastCollective removeAllObjects];
        [currentCollective removeAllObjects];
        
        if ([fiscPer count] > 0) {
            
            for (int sayac = 0; sayac<[fiscPer count]; sayac++) {
                
                NSString *fiscp     = [fiscPer objectAtIndex:sayac];
                NSString *fiscp3    = [fiscPer3 objectAtIndex:sayac];
                NSString *fiscyr    = [fiscYear objectAtIndex:sayac];
                NSString *costelmnt = [costElmnt objectAtIndex:sayac];
                NSString *fiscper1  = [fiscPer objectAtIndex:sayac];
                NSString *value     = [tutar objectAtIndex:sayac];
                NSString *vtyp      = [vtype objectAtIndex:sayac];
                
                NSArray  *expenseArr = [NSArray arrayWithObjects:fiscp,fiscp3,fiscyr,costelmnt,fiscper1,value,vtyp,nil];
                
                [expenseReport addObject:expenseArr];
            }
//            [super stopAnimationOnView];
            //            [tableView reloadData];
        }
        if ([lastCollCost count] > 0)
        {
            for (int i = 0; i<[lastCollCost count]; i++) {
                NSString *lastCost  = [lastCollCost objectAtIndex:i];
                NSString *lastTutar = [lastCollTutar objectAtIndex:i];
                NSString *lastVtype = [lastCollVtype objectAtIndex:i];
                
                NSArray *lastArr = [NSArray arrayWithObjects:lastCost,lastTutar,lastVtype, nil];
                
                [lastCollective addObject:lastArr];
            }
            
        }
        if ([currCollCost count] > 0)
        {
            for (int i = 0; i<[currCollCost count]; i++) {
                NSString *currCost = [currCollCost objectAtIndex:i];
                NSString *currTutar = [currCollTutar objectAtIndex:i];
                NSString *currVtype = [currCollVtype objectAtIndex:i];
                
                NSArray *currArr = [NSArray arrayWithObjects:currCost,currTutar,currVtype, nil];

                [currentCollective addObject:currArr];
                
            }
            

//            [super stopAnimationOnView];
        }
        
        if ([currDistCost count] > 0)
        {
            for (int i = 0; i<[currDistCost count]; i++) {
                NSString *distCost = [currDistCost objectAtIndex:i];
                NSString *distTutar = [currDistTutar objectAtIndex:i];
                NSString *distVtype = [currDistVtype objectAtIndex:i];
                NSString *distDesc = [currDistDesc objectAtIndex:i];
                
                NSArray *distArr = [NSArray arrayWithObjects:distCost,distDesc,distTutar,distVtype, nil];
                
                [currentCollectiveDistinct addObject:distArr];
                
            }
            
//            [super stopAnimationOnView];
            [tableView reloadData];
        }
        
        else
        {
            [super stopAnimationOnView];
        }
        
        [super stopAnimationOnView];
    }
    else
    {
        [super stopAnimationOnView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Bu kullanıcıya ait masraf raporu bulunmamaktadır!" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [CSApplicationHelper getMonthFromNumber:row];
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentCollectiveDistinct count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];

    NSString *costElmnt = [[currentCollectiveDistinct objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *description = [[currentCollectiveDistinct  objectAtIndex:indexPath.row] objectAtIndex:1];
//    NSString *currValue = [[currentCollectiveDistinct objectAtIndex:indexPath.row] objectAtIndex:2];
//    NSString *vtype = [[currentCollectiveDistinct objectAtIndex:indexPath.row] objectAtIndex:3];
 
    NSString *currBorcTutar;
    NSString *currMasrafTutar;
    
    NSString *lastBorcTutar;
    NSString *lastMasrafTutar;
    
        for (int i = 0; i < [lastCollective count]; i++) {
            if ([costElmnt isEqualToString:[[lastCollective objectAtIndex:i] objectAtIndex:0]])
            {
                lastMasrafTutar = [[lastCollective objectAtIndex:i] objectAtIndex:1];
            }
            else
            {
                lastBorcTutar = [[lastCollective objectAtIndex:i] objectAtIndex:1];
            }
        }
    
        for (int i = 0; i < [currentCollective count]; i++) {
            if ([costElmnt isEqualToString:[[currentCollective objectAtIndex:i] objectAtIndex:0]])
            {
                if ([[[currentCollective objectAtIndex:i]objectAtIndex:2] isEqualToString:@"010"]) {
                    currMasrafTutar = [[currentCollective objectAtIndex:i] objectAtIndex:1];
                }
                else
                {
                    currBorcTutar = [[currentCollective objectAtIndex:i] objectAtIndex:1];
                }
            }
        }
    
    
        if (currMasrafTutar == NULL) {
            currMasrafTutar = @"0.00";
        }
        if (currBorcTutar == NULL) {
            currBorcTutar = @"0.00";
        }
        if (lastMasrafTutar == NULL)
        {
            lastMasrafTutar = @"0.00";
        }
        if (lastBorcTutar == NULL)
        {
            lastBorcTutar = @"0.00";
        }
    
        [[cell textLabel]setText:description];
        [[cell textLabel]setFont:[UIFont boldSystemFontOfSize:15]];
    
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setNumberOfLines:0];
    
        [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:12]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Masraf: %@     %d Bütçe: %@\n%d Masraf: %@     %d Bütçe: %@",[components year],[ABHXMLHelper correctNumberValue:currMasrafTutar],[components year],[ABHXMLHelper correctNumberValue:currBorcTutar],[components year]-1,[ABHXMLHelper correctNumberValue:lastMasrafTutar],[components year]-1,[ABHXMLHelper correctNumberValue:lastBorcTutar]];
    
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 70.0f;
    }else{
        return 70.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *costElmnt = [[currentCollectiveDistinct objectAtIndex:indexPath.row] objectAtIndex:0];
    NSString *desc = [[currentCollectiveDistinct  objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [expenseReportMonth removeAllObjects];
    
    for(int i = 0; i < [expenseReport count];i++)
    {
        if ([costElmnt isEqualToString:[[expenseReport objectAtIndex:i] objectAtIndex:3]]) {
            
            NSString *month = [[expenseReport objectAtIndex:i] objectAtIndex:1];
            NSString *value = [ABHXMLHelper correctNumberValue:[[expenseReport objectAtIndex:i]objectAtIndex:5]];
            NSString *vtype = [[expenseReport objectAtIndex:i] objectAtIndex:6];
            
            NSArray *monthArr = [NSArray arrayWithObjects:month,value,vtype, nil];
            
            [expenseReportMonth addObject:monthArr];
        }
    }
    
    NSString *nibName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        nibName = @"CSExpenseDetailReportViewController_Ipad";
    }else{
        nibName = @"CSExpenseDetailReportViewController";
    }
    
    CSExpenseDetailReportViewController *detailExpenses = [[CSExpenseDetailReportViewController alloc]initWithArray:expenseReportMonth andNibName:nibName andDescription:desc];
    
    [[self navigationController] pushViewController:detailExpenses animated:YES];
}
@end
