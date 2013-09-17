//
//  CSESatisReportsViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 16.05.2013.
//
//

#import "CSESatisReportsViewController.h"

@interface CSESatisReportsViewController ()

@end

@implementation CSESatisReportsViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(CSUser *)myUser;
{
//    user = [[CSUser alloc] init];
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
    [[self navigationItem] setTitle:@"E-Satis Raporları"];
    
//    user = [[CSUser alloc] init];
//    
//    CSAppDelegate *del = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (del.otherMykUser == nil)
//    {
//        user.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
//    }
//    else
//    {
//        user.username = del.otherMykUser;
//    }
////    user.sapUser  = [[NSUserDefaults standardUserDefaults] stringForKey:@"sapUser"];
//    user.javaPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"javaPassword"];
//    
//    [self getSapUSer];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewRiskReports:(CSUser*)myUser {
    CSRiskReportViewController *riskReports = [[CSRiskReportViewController alloc] initWithUser:[self user]];
    [[self navigationController] pushViewController:riskReports animated:YES];
}

- (void)showESatisWebPageWithImportParameters:(NSString *)i_pageName {
    NSString *prefix;
    NSString *urlAdress;
    
    if ([i_pageName isEqualToString:@"Rapor Yazma"]) {
        prefix = @"http://e-yonetici.efespilsen.com.tr/mobilGiris?";
        urlAdress = [NSString stringWithFormat:@"%@username=%@&menu=anasayfa&password=%@", prefix, [[user sapUser] uppercaseString], [user javaPassword]];
        
    }
    else
    {
        prefix = @"http://e-satis.efespilsen.com.tr/ortak/mobilGiris.do?sayfaAdi=";
        urlAdress = [NSString stringWithFormat:@"%@%@&sapUserName=%@&sapKey=%@", prefix, i_pageName, [[user sapUser] uppercaseString], [user javaPassword]];
    }
    
    CSSharePointSafariViewController *webView = [[CSSharePointSafariViewController alloc] initWithURL:urlAdress];
    [[self navigationController] pushViewController:webView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    if (section == 0) {
        if (row == 0)
            cell.textLabel.text = @"E-Rapor";
        if (row == 1)
            cell.textLabel.text = @"E-Satış Talep Tahmin Girişi";
    }
    else if (section == 1) {
        if (row == 0)
            cell.textLabel.text = @"Teminat Yönetimi";
        if (row == 1)
            cell.textLabel.text = @"Kredi Yönetimi";
        if (row == 2)
            cell.textLabel.text = @"Risk Göster";
        if (row == 3)
            cell.textLabel.text = @"Bayii/Dist. Risk Raporu";
    }
    else if (section == 2) {
        if (row == 0)
            cell.textLabel.text = @"Bakiye Görüntüleme";
        if (row == 1)
            cell.textLabel.text = @"Talimatlar";
        if (row == 2)
            cell.textLabel.text = @"Vade Farkı";
        if (row == 3)
            cell.textLabel.text = @"Ödemeler Tarih Aralığı";
        if (row == 4)
            cell.textLabel.text = @"Ödemeler Günlük";
    }
    else if (section == 3) {
        if (row == 0)
            cell.textLabel.text = @"Bekleyen Siparişler";
        if (row == 1)
            cell.textLabel.text = @"Bekleyen Litre";
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == 0) {
        if (row == 0)
            [self showESatisWebPageWithImportParameters:@"Rapor Yazma"];
        if (row == 1)
//            [self showESatisWebPageWithImportParameters:@"yillikTalepTahminGirisRapor"];
            [self showESatisWebPageWithImportParameters:@"TalepTahminGirisi"];
        
    }
    else if (section == 1) {
        if (row == 0)
            [self showESatisWebPageWithImportParameters:@"teminatYonetimi"];
        if (row == 1)
            [self showESatisWebPageWithImportParameters:@"krediYonetimi"];
        if (row == 2)
            [self showESatisWebPageWithImportParameters:@"riskGetir"];
        if (row == 3)
            [self viewRiskReports:[self user]];
    }
    else if (section == 2) {
        if (row == 0)
            [self showESatisWebPageWithImportParameters:@"bakiyeGoruntule"];
        if (row == 1)
            [self showESatisWebPageWithImportParameters:@"talimatlar"];
        if (row == 2)
            [self showESatisWebPageWithImportParameters:@"vadeFarki"];
        if (row == 3)
            [self showESatisWebPageWithImportParameters:@"dbsToplam"];
        if (row == 4)
            [self showESatisWebPageWithImportParameters:@"dbsGunluk"];
    }
    else if (section == 3) {
        if (row == 0)
            [self showESatisWebPageWithImportParameters:@"siparisListeleme"];
        if (row == 1)
            [self showESatisWebPageWithImportParameters:@"siparisDurumBilgisi"];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = @"E-Satış Raporları ve Talep Tahmini";
            break;
        case 1:
            sectionName = @"Risk Yönetimi";
            break;
        case 2:
            sectionName = @"Borç Yönetimi";
            break;
        case 3:
            sectionName = @"Sipariş Yönetimi";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    
    switch (section)
    {
        case 0:
            label.text = @"E-Satış Raporları ve Talep Tahmini";
            break;
        case 1:
            label.text = @"Risk Yönetimi";
            break;
        case 2:
            label.text = @"Borç Yönetimi";
            break;
        case 3:
            label.text = @"Sipariş Yönetimi";
            break;
        default:
            label.text = @"";
            break;
    }
    
    label.textColor = [UIColor whiteColor];
    
    label.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:label];
    
    return headerView;
}
@end
