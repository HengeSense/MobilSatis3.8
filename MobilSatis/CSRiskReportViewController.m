//
//  CSFinancialReportViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 09.05.2013.
//
//

#import "CSRiskReportViewController.h"

@interface CSRiskReportViewController ()

@end

@implementation CSRiskReportViewController
@synthesize tableView, pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithUser:(CSUser *)myUser
{
    self = [super initWithUser:myUser];
    user.javaPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"javaPassword"];
    [self getSapUSer];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    [[self navigationItem] setTitle:@"Toplam Risk Bilgileri"];
    
    generalFinanceReport = [[CSFinancialReport alloc] initWithArray];
    distrList = [[NSMutableArray alloc] init];
    responseBuffer = [[NSString alloc] init];
    pickerViewList = [[NSMutableArray alloc] init];
    
//    user = [[CSUser alloc] init];
//    user.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
//    user.sapUser  = [[NSUserDefaults standardUserDefaults] stringForKey:@"sapUser"];
    
    [self getDistributionSaleDataFromSOAP];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getSapUSer
{
    [super playAnimationOnView:self.view];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_GET_SAPUSER"];
    
    [sapHandler addImportWithKey:@"I_MYK" andValue:user.username];
    [sapHandler setDelegate:self];
    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    NSString *sapUser = [[ABHXMLHelper getValuesWithTag:@"E_SAPUSER" fromEnvelope:myResponse] objectAtIndex:0];
    
    user.sapUser = sapUser;
    
    [super stopAnimationOnView];
    
}

- (void)getDistributionSaleDataFromSOAP {
    ESatisHandler *handler = [[ESatisHandler alloc] initWithConnectionUrl:@"http://webservice.efespilsen.com.tr/services/BayiDistRiskWebService"];
    [handler setDelegate:self];
    //    [handler prepCallToGetMasrafYeriRiskBilgileri:@"erdeno"];
    [handler prepCallToGetMasrafYeriRiskBilgileri:[user sapUser]];
    [handler prepCall];
    
    [super playAnimationOnView:self.view];
}

- (void)getResponseFromSOAP:(NSString *)myResponse {
    [super stopAnimationOnView];
    @try {
        responseBuffer = myResponse;
        
        if ([[[ABHXMLHelper getValuesWithTag:@"toplamRiskDolu" fromEnvelope:myResponse] objectAtIndex:0] isEqualToString:@"false"]) {
            [self initDealerListFromEnvelope:[ABHXMLHelper getValuesWithTag:@"bayiDistRisk" fromEnvelope:myResponse]];
            return;
        }
        [self initGeneralFinanceReport:[[ABHXMLHelper getValuesWithTag:@"genelToplamRisk" fromEnvelope:myResponse] objectAtIndex:0]];
        [self fillDistributorNames:[ABHXMLHelper getValuesWithTag:@"bayiDistRisk" fromEnvelope:myResponse]];
    }
    @catch (NSException *exception) {
        NSLog(@"deneme");
    }
    @finally {
        
    }
}

- (void)initGeneralFinanceReport:(NSString *)envelope {
    @try {
        generalFinanceReport.abankTutar = [[ABHXMLHelper getValuesWithTag:@"abankgTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.acikSiparisLitre = [[ABHXMLHelper getValuesWithTag:@"acikSiparisLitre" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.acikKalanTutar = [[ABHXMLHelper getValuesWithTag:@"acik_kalTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.acikSiparisTutar = [[ABHXMLHelper getValuesWithTag:@"aciksipTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.akKrediTutar = [[ABHXMLHelper getValuesWithTag:@"akkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.ekKrediTutar = [[ABHXMLHelper getValuesWithTag:@"ekkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.ekLimitTutar = [[ABHXMLHelper getValuesWithTag:@"eklimitTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.eTeminatTutar = [[ABHXMLHelper getValuesWithTag:@"eteminatTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.kanunTakTutar = [[ABHXMLHelper getValuesWithTag:@"kanun_takTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.kulToplamTutar = [[ABHXMLHelper getValuesWithTag:@"kulToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.malLimitTutar = [[ABHXMLHelper getValuesWithTag:@"malimitTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.sipToplamTutar = [[ABHXMLHelper getValuesWithTag:@"sipToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.toplamBorcTutar = [[ABHXMLHelper getValuesWithTag:@"topborcTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.toplamEfesBorcTutar = [[ABHXMLHelper getValuesWithTag:@"toplamEfesBorcTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.toplamTeminatTutar = [[ABHXMLHelper getValuesWithTag:@"toplamTeminatTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.tpKrediTutar = [[ABHXMLHelper getValuesWithTag:@"tpkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.tplRiskTutar = [[ABHXMLHelper getValuesWithTag:@"tplriskTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vgcCekTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_kcekTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vgcSenetTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_psenetTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vgcTalimatTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_talimatTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vgcToplamTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_toplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vglCekTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_cekTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vglSenetTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_senetTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vglTalimatTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_talimatTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.vglToplamTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_toplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.yeniSiparisToplamTutar = [[ABHXMLHelper getValuesWithTag:@"yeniSipToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.musteriAdi = [[ABHXMLHelper getValuesWithTag:@"musteriAdi" fromEnvelope:envelope] objectAtIndex:0];
        generalFinanceReport.musteriNo  = [[ABHXMLHelper getValuesWithTag:@"musteriNo" fromEnvelope:envelope] objectAtIndex:0];
        
        generalFinanceReport.isFilled = YES;
        
        NSArray *productGroupNumber = [ABHXMLHelper getValuesWithTag:@"malGrubuLitreleri" fromEnvelope:envelope];
        
        for (int i = 1; i < [productGroupNumber count]; i++) {
            NSString *productName = [[ABHXMLHelper getValuesWithTag:@"adi" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSString *productCode = [[ABHXMLHelper getValuesWithTag:@"kodu" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSString *productLitre = [[ABHXMLHelper getValuesWithTag:@"litre" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSArray *arr = [NSArray arrayWithObjects:productName, productCode, productLitre, nil];
            [generalFinanceReport.malGrubuLitreleri addObject:arr];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [tableView reloadData];
}

- (void)fillDistributorNames:(NSArray *)distArray {
    @try {
        
        for (int i = 1; i < [distArray count]; i++) {
            NSString *custName = [[ABHXMLHelper getValuesWithTag:@"musteriAdi" fromEnvelope:[distArray objectAtIndex:i]] objectAtIndex:0];
            NSString *custNumber = [[ABHXMLHelper getValuesWithTag:@"musteriNo" fromEnvelope:[distArray objectAtIndex:i]] objectAtIndex:0];
            NSArray *arr = [NSArray arrayWithObjects:custName, custNumber, nil];
            [distrList addObject:arr];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [tableView reloadData];
}

- (void)distributorHasBeenSelected:(int)row {
    @try {
        NSArray *arrayOfDist = [ABHXMLHelper getValuesWithTag:@"bayiDistRisk" fromEnvelope:responseBuffer];
        
        for (int i = 1; i < [arrayOfDist count]; i++) {
            if ([[[ABHXMLHelper getValuesWithTag:@"musteriNo" fromEnvelope:[arrayOfDist objectAtIndex:i]] objectAtIndex:0] isEqualToString:[[distrList objectAtIndex:row] objectAtIndex:1]]) {
                [self initDistributorReport:[arrayOfDist objectAtIndex:i]];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)initDistributorReport:(NSString *)envelope {
    
    CSFinancialReport *report = [[CSFinancialReport alloc] initWithArray];
    
    @try {
        report.abankTutar = [[ABHXMLHelper getValuesWithTag:@"abankgTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.acikSiparisLitre = [[ABHXMLHelper getValuesWithTag:@"acikSiparisLitre" fromEnvelope:envelope] objectAtIndex:0];
        report.acikKalanTutar = [[ABHXMLHelper getValuesWithTag:@"acik_kalTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.acikSiparisTutar = [[ABHXMLHelper getValuesWithTag:@"aciksipTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.akKrediTutar = [[ABHXMLHelper getValuesWithTag:@"akkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.ekKrediTutar = [[ABHXMLHelper getValuesWithTag:@"ekkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.ekLimitTutar = [[ABHXMLHelper getValuesWithTag:@"eklimitTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.eTeminatTutar = [[ABHXMLHelper getValuesWithTag:@"eteminatTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.kanunTakTutar = [[ABHXMLHelper getValuesWithTag:@"kanun_takTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.kulToplamTutar = [[ABHXMLHelper getValuesWithTag:@"kulToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.malLimitTutar = [[ABHXMLHelper getValuesWithTag:@"malimitTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.sipToplamTutar = [[ABHXMLHelper getValuesWithTag:@"sipToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.toplamBorcTutar = [[ABHXMLHelper getValuesWithTag:@"topborcTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.toplamEfesBorcTutar = [[ABHXMLHelper getValuesWithTag:@"toplamEfesBorcTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.toplamTeminatTutar = [[ABHXMLHelper getValuesWithTag:@"toplamTeminatTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.tpKrediTutar = [[ABHXMLHelper getValuesWithTag:@"tpkrediTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.tplRiskTutar = [[ABHXMLHelper getValuesWithTag:@"tplriskTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vgcCekTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_kcekTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vgcSenetTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_psenetTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vgcTalimatTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_talimatTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vgcToplamTutar = [[ABHXMLHelper getValuesWithTag:@"vgc_toplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vglCekTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_cekTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vglSenetTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_senetTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vglTalimatTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_talimatTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.vglToplamTutar = [[ABHXMLHelper getValuesWithTag:@"vgl_toplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.yeniSiparisToplamTutar = [[ABHXMLHelper getValuesWithTag:@"yeniSipToplamTutar" fromEnvelope:envelope] objectAtIndex:0];
        report.musteriAdi = [[ABHXMLHelper getValuesWithTag:@"musteriAdi" fromEnvelope:envelope] objectAtIndex:0];
        report.musteriNo  = [[ABHXMLHelper getValuesWithTag:@"musteriNo" fromEnvelope:envelope] objectAtIndex:0];
        
        report.isFilled = YES;
        
        NSArray *productGroupNumber = [ABHXMLHelper getValuesWithTag:@"malGrubuLitreleri" fromEnvelope:envelope];
        
        for (int i = 1; i < [productGroupNumber count]; i++) {
            NSString *productName = [[ABHXMLHelper getValuesWithTag:@"adi" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSString *productCode = [[ABHXMLHelper getValuesWithTag:@"kodu" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSString *productLitre = [[ABHXMLHelper getValuesWithTag:@"litre" fromEnvelope:[productGroupNumber objectAtIndex:i]] objectAtIndex:0];
            NSArray *arr = [NSArray arrayWithObjects:productName, productCode, productLitre, nil];
            [report.malGrubuLitreleri addObject:arr];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if ([report isFilled] == YES)
        [self showDistributorReport:report];
}

- (void)initDealerListFromEnvelope:(NSArray *)itemArray {
    
    for (int i = 1; i < [itemArray count]; i++) {
        NSString *kunnr = [[ABHXMLHelper getValuesWithTag:@"mudurlukNo" fromEnvelope:[itemArray objectAtIndex:i]] objectAtIndex:0];
        if (![kunnr isEqualToString:@""])
        {
            NSString *name1 = [[ABHXMLHelper getValuesWithTag:@"mudurlukAdi" fromEnvelope:[itemArray objectAtIndex:i]] objectAtIndex:0];
            NSArray *arr = [NSArray arrayWithObjects:kunnr, name1, nil];
            if (i > 1 && [[[pickerViewList lastObject] objectAtIndex:0] isEqualToString:kunnr])
                continue;
            
            [pickerViewList addObject:arr];
        }
    }
    if ([pickerViewList count] > 0)
    {
        [pickerView setHidden:NO];
        [pickerView reloadAllComponents];
        [super stopAnimationOnView];
        
        UIBarButtonItem *changeButton = [[UIBarButtonItem alloc] initWithTitle:@"Seç" style:UIBarButtonItemStyleBordered target:self action:@selector(changeButtonClicked)];
        [[self navigationItem] setRightBarButtonItem:changeButton];
    }
}

- (void)showDistributorReport:(CSFinancialReport *)report {
    CSRiskReportDetailViewController *distReportViewController = [[CSRiskReportDetailViewController alloc] initWithReport:report];
    [[self navigationController] pushViewController:distReportViewController animated:YES];
}

- (void)pickerViewRowSelected:(id)sender {
    ESatisHandler *handler = [[ESatisHandler alloc] initWithConnectionUrl:@"http://webservice.efespilsen.com.tr/services/BayiDistRiskWebService"];
    [handler setDelegate:self];
    [handler prepCallToGetMudurlukMasrafYeriRiskBilgileri:[[pickerViewList objectAtIndex:selectedRow] objectAtIndex:0] : [user sapUser]];
    [handler prepCall];
    [super playAnimationOnView:self.view];
}

- (void)changeButtonClicked {
    if (![super isAnimationRunning]) {
        if ([[[[self navigationItem] rightBarButtonItem] title] isEqualToString:@"Seç"]) {
            [self pickerViewRowSelected:nil];
            [[[self navigationItem] rightBarButtonItem] setTitle:@"Değiştir"];
            [[self pickerView] setHidden:YES];
        }
        else
        {
            [[[self navigationItem] rightBarButtonItem] setTitle:@"Seç"];
            [[self pickerView] setHidden:NO];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if ([generalFinanceReport isFilled] == YES)
                return 16 + [[generalFinanceReport malGrubuLitreleri] count];
            else
                return 0;
            break;
        case 1:
            return [distrList count];
            break;
        default:
            return 1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (section == 0) {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Toplam Teminat Tutar";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.eTeminatTutar];
                break;
            case 1:
                cell.textLabel.text = @"Banka Güvencesi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.abankTutar];
                break;
            case 2:
                cell.textLabel.text = @"Mal Alma Limiti";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.malLimitTutar];
                break;
            case 3:
                cell.textLabel.text = @"EFPA Kredi Limiti";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.ekLimitTutar];
                break;
            case 4:
                cell.textLabel.text = @"EFPA K.Bilir Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.ekKrediTutar];
                break;
            case 5:
                cell.textLabel.text = @"Banka K.Bilir Kredi";
                cell.detailTextLabel.text = generalFinanceReport.akKrediTutar;
                break;
            case 6:
                cell.textLabel.text = @"Toplam Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f",[generalFinanceReport.ekKrediTutar floatValue] + [generalFinanceReport.akKrediTutar floatValue]]];
                break;
            case 7:
                cell.textLabel.text = @"Toplam K.Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f", [generalFinanceReport.ekLimitTutar floatValue] - ([generalFinanceReport.vglToplamTutar floatValue] + [generalFinanceReport.vgcToplamTutar floatValue] + [generalFinanceReport.kanunTakTutar floatValue] + [generalFinanceReport.acikKalanTutar floatValue]) ]];
                break;
            case 8:
                cell.textLabel.text = @"Toplam C/H Borcu";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f", [generalFinanceReport.vglToplamTutar floatValue] + [generalFinanceReport.vgcToplamTutar floatValue] + [generalFinanceReport.kanunTakTutar floatValue] + [generalFinanceReport.acikKalanTutar floatValue]]];
                break;
            case 9:
                cell.textLabel.text = @"V.Gel. Talimat";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.vglTalimatTutar];
                break;
            case 10:
                cell.textLabel.text = @"V.Gel. Çekler";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.vglCekTutar];
                break;
            case 11:
                cell.textLabel.text = @"V.Gel. Toplam";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.vglToplamTutar];
                break;
            case 12:
                cell.textLabel.text = @"V.Geç. Talimat";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.vgcTalimatTutar];
                break;
            case 13:
                cell.textLabel.text = @"V.Geç Toplam";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.vgcToplamTutar];
                break;
            case 14:
                cell.textLabel.text = @"Açık Kalem";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:generalFinanceReport.acikKalanTutar];
                break;
            case 15:
                cell.textLabel.text = @"Yeni Siparis Toplam Tutar";
                cell.detailTextLabel.text = generalFinanceReport.yeniSiparisToplamTutar;
                break;
            default:
                break;
        }
        if (row > 25) {
            cell.textLabel.text = [[[generalFinanceReport malGrubuLitreleri] objectAtIndex:row - 26] objectAtIndex:0];
            cell.detailTextLabel.text = [[[generalFinanceReport malGrubuLitreleri] objectAtIndex:row - 26] objectAtIndex:2];
        } 
        //cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:cell.detailTextLabel.text]; Doktor bu ne ?!? :D
    }
    else
    {
        [cell.textLabel setText:[[distrList objectAtIndex:row] objectAtIndex:0]];
        [cell.detailTextLabel setText:[[distrList objectAtIndex:row] objectAtIndex:1]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (![super isAnimationRunning]) {
        if (section == 0 && [[self navigationItem] rightBarButtonItem] != nil) {
            [[[self navigationItem] rightBarButtonItem] setTitle:@"Değiştir"];
            [[self pickerView] setHidden:YES];
        }
        if (section == 1) {
            [self distributorHasBeenSelected:row];
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerViewList count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[pickerViewList objectAtIndex:row] objectAtIndex:1];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        return 650;
    }
    else {
        return 300;
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedRow = row;
}

@end
