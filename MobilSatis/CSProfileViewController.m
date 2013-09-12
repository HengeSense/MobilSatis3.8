//
//  CSProfileViewController.m
//  MobilSatis
//
//  Created by ABH on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CSProfileViewController.h"

@interface CSProfileViewController ()

@end

@implementation CSProfileViewController
@synthesize TableView;
@synthesize welcomeLabel,defaultMyk, newVersion;


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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self = [super initWithNibName:@"CSProfileViewController_Ipad" bundle:nil];
    }
    
    return self;
}

- (void)viewConfirmations{
    CSConfirmationListViewController *confirmationListViewController = [[CSConfirmationListViewController alloc] initWithUser:user];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[self navigationController] pushViewController:confirmationListViewController animated:NO];
        
    }else{
        [[[self tabBarController] navigationController]
         pushViewController:confirmationListViewController animated:YES];
    }
}

- (void)viewSales{
    CSUserSalesViewController *userSalesViewController = [[CSUserSalesViewController alloc] initWithUser:user];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[self navigationController] pushViewController:userSalesViewController animated:NO];
        
    }else{
        [[[self tabBarController] navigationController] pushViewController:userSalesViewController animated:YES];
    }
}

- (void)viewEfesPilsenCommercials {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CSEfesPilsenCommercialsViewController *efesPilsenCommercialsViewController = [[CSEfesPilsenCommercialsViewController alloc] initWithNibName:@"CSEfesPilsenCommercialsViewController_Ipad" bundle:nil];
        [[self navigationController] pushViewController:efesPilsenCommercialsViewController animated:NO];
        
    }else{
        CSEfesPilsenCommercialsViewController *efesPilsenCommercialsViewController = [[CSEfesPilsenCommercialsViewController alloc] init];
        [[[self tabBarController] navigationController] pushViewController:efesPilsenCommercialsViewController animated:YES];
    }
}

- (void)viewConnectWithOtherMYK {
    CSConnectWithOtherMYKViewController *connectWithOtherMYKViewController = [[CSConnectWithOtherMYKViewController alloc] initWithUser:[self user]];
    [[self navigationController] pushViewController:connectWithOtherMYKViewController animated:YES];
}

- (void)viewESatisReports {
    CSESatisReportsViewController *esatisReportsViewController = [[CSESatisReportsViewController alloc] initWithUser:[self user]];
    [[self navigationController] pushViewController:esatisReportsViewController animated:YES];
}

- (void)viewSalesRepresentative{
    CSSalesRepresentativeViewController *salesRepresentative = [[CSSalesRepresentativeViewController alloc]initWithUser:[self user]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[self navigationController] pushViewController:salesRepresentative animated:NO];
        
    }else{
        [[[self tabBarController] navigationController]
         pushViewController:salesRepresentative animated:YES];
    }
}

- (void)setVisitPlan{
    CSVisitPlanViewController *visitPlan = [[CSVisitPlanViewController alloc] initWithUser:[self user]];
    
    [[self navigationController] pushViewController:visitPlan animated:YES];
}

- (void)viewExpenseReportFromBW{
//    CSExpenseReportViewController *expenseReport = [[CSExpenseReportViewController alloc] initWithUser:[self user]];
//    
//    [[self navigationController] pushViewController:expenseReport animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Bir sonraki versiyon geçişiyle aktif hale gelecektir." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
    
    [alert show];
    return;
}

- (void)viewCampaigns
{
    CSCampaignViewController *campaign = [[CSCampaignViewController alloc] initWithUser:[self user]];
    
    [[self navigationController] pushViewController:campaign animated:YES];
}

- (void)viewSurveyQuestions{
    
    NSString *nibName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        nibName = @"CSSurveySelectionViewController_Ipad";
    }else{
        nibName = @"CSSurveySelectionViewController";
    }
    
    CSSurveySelectionViewController *surveyQuestions = [[CSSurveySelectionViewController alloc] initWithNibName:nibName bundle:nil];
    
    [[self navigationController] pushViewController:surveyQuestions animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil animated:YES];
    [welcomeLabel setText:[NSString stringWithFormat:@"%@ %@",welcomeLabel.text,user.name]];
    TableView.backgroundColor = [UIColor clearColor];
    TableView.opaque = NO;
    TableView.backgroundView = nil;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpCompleted) name:@"startUpCompleted" object:nil];
    
    if (newVersion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Efes Mobil uygulamasının yeni versiyonu mevcuttur. İndirmek ister misiniz?" delegate:self cancelButtonTitle:@"Daha sonra" otherButtonTitles:@"İndir", nil];
        alert.tag = 1;
        [alert show];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Yenile" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshConfirmations)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Kullanıcıma Dön" style:UIBarButtonItemStyleBordered target:self action:@selector(returnOwnMyk)];
    
    CSAppDelegate *del = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [[self navigationItem] setTitle:@"Profilim"];
        if (del.otherMykUser == nil)
        {
            [[self navigationItem] setRightBarButtonItem:nil animated:YES];
        }
        else
        {
            [[self navigationItem] setRightBarButtonItem:nextButton animated:YES];
        }
    }
    else
    {
        if (del.otherMykUser == nil)
        {
            [[[self tabBarController ]navigationItem] setRightBarButtonItem:nil];
        }
        else
        {
            [[[self tabBarController ]navigationItem] setRightBarButtonItem:nextButton];
        }
        [[[self tabBarController ]navigationItem] setTitle:@"Profilim"];
    }
    
    //[myTableView reloadData];
}

- (void)returnOwnMyk
{
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_CONNECT_WITH_OTHER_MYK"];
    [sapHandler addImportWithKey:@"I_PARTNER" andValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
    [sapHandler prepCall];
    
    CSAppDelegate *del = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
    del.otherMykUser = nil;
    
    [super playAnimationOnView:self.view];

//
//    CSLoginViewController *login = [[CSLoginViewController alloc] init];
//    
//    UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController:login];
//    [self presentModalViewController:cont animated:YES];
//    login.username.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
}
- (void)startUpCompleted {
    
    NSArray *arr = [[self navigationController] viewControllers];
    
    for (int i = 0; i < [arr count]; i++) {
        if ([[[[arr objectAtIndex:i] class] description] isEqualToString:@"CSLoginViewController"]) {
            CSBaseViewController *base = [arr objectAtIndex:i];
            [base stopAnimationOnView];
        }
    }
    [super stopAnimationOnView];
    
    if (![CoreDataHandler isInternetConnectionNotAvailable])
        [self checkCoreDataForWaitingVisit];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 3) {
        if (buttonIndex == 1) {
            [self sendVisitDetailViaCoreData];
        }
    }
    else if([alertView tag] == 2)
    {
        NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
        CDOVisitDetail *visitDetail = [arr objectAtIndex:0];
        
        [[CoreDataHandler getManagedObject] deleteObject:visitDetail];
        [CoreDataHandler saveEntityData];
        
        [self checkCoreDataForWaitingVisit];
    }
    else if([alertView tag] == 1)
    {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:@"http://www.efespilsen.com.tr/efesmobil/"];
            [[UIApplication sharedApplication] openURL:url];
        }

    }
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    [super stopAnimationOnView];
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_CONNECT_WITH_OTHER_MYK" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSRange range = [myResponse rangeOfString:@"E_RETURN"];
        if (range.length > 0) {
            NSString *e_return = [[ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
            if (![e_return isEqualToString:@"F"]) {
                {
                    CSLoginViewController *login = [[CSLoginViewController alloc] init];
                    
                    UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController:login];
                    [self presentModalViewController:cont animated:YES];
                    login.username.text = [[ABHXMLHelper getValuesWithTag:@"E_PARTNER" fromEnvelope:myResponse] objectAtIndex:0];
                    login.password.text = [[ABHXMLHelper getValuesWithTag:@"E_PASSWORD" fromEnvelope:myResponse] objectAtIndex:0];
                    login.user.sapUser = [[ABHXMLHelper getValuesWithTag:@"E_SAPUSER" fromEnvelope:myResponse] objectAtIndex:0];
                    
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Seçilen kullanıcı ile alakalı hata alındı." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else
    {
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
    
    if ([responses count] > 0) {
        NSString *booleanValue = [responses objectAtIndex:0];
        
        if ([booleanValue isEqualToString:@"T"]) {
            responses = [ABHXMLHelper getValuesWithTag:@"OBJ_ID" fromEnvelope:myResponse];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Başarılı" message:[NSString stringWithFormat:@"Ziyaret yapıldı, %@ numaralı belge yaratıldı.", [responses objectAtIndex:0]] delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            [alert setTag:2];
            [alert show];
        }
        else if([booleanValue isEqualToString: @"Y"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Rekabet mevzuatı ve Rekabet Kurulu kararları gereği, yazdığınız açıklama kabul olmadığından ziyaret kaydedilemedi." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hata" message:@"Sistemde hata oluştu. Ziyaret kaydedilemedi." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
            alert.tag = 2;
            [alert show];
        }
    }
    }
}

# pragma mark - Core Data

- (void)checkCoreDataForWaitingVisit {
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
    
    if ([arr count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Cihazınızda bekleyen Ziyaret detayları var, SAP'ye göndermek ister misiniz ? " delegate:self cancelButtonTitle:@"Hayır" otherButtonTitles:@"Evet", nil];
        [alert setTag:3];
        [alert show];
    }
    
}

- (void)sendVisitDetailViaCoreData {
    
    NSArray *arr = [CoreDataHandler fetchExistingEntityData:@"CDOVisitDetail" sortingParameter:@"customerNumber" objectContext:[CoreDataHandler getManagedObject]];
    CDOVisitDetail *tempVisitDetail = [arr objectAtIndex:0];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo  getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword] andRFCName:@"ZMOB_ZIYARET_GIRIS"];
    [sapHandler addImportWithKey:@"I_UNAME" andValue:[tempVisitDetail userMyk]];
    [sapHandler addImportWithKey:@"I_CUST" andValue:[tempVisitDetail customerNumber]];
    [sapHandler addImportWithKey:@"I_TYPE" andValue:@"G"];
    [sapHandler addImportWithKey:@"I_TEXT" andValue:[tempVisitDetail text]];
    [sapHandler addTableWithName:@"T_RETURN" andColumns:[NSMutableArray arrayWithObjects:@"KUNNR",@"DATE",@"STATUS", nil]];
    
    [super playAnimationOnView:self.view];
    
    [sapHandler prepCall];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [recievedDataInArray count];
    if (section == 0) {
        return 1;
    }
    else {
        return 10;
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
    
    if (section == 0) {
        cell.textLabel.text = @"Hoşgeldiniz";
        cell.detailTextLabel.text = user.name;
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    else {
        switch (row) {
            case 0:
                cell.textLabel.text = @"Satışlarım";
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.imageView.image = [UIImage imageNamed:@"maviappiconlar-07.png"];
                break;
            case 1:
                cell.textLabel.text = @"Soğutucu Onayları";
                cell.imageView.image = [UIImage imageNamed:@"maviappiconlar-08.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 2:
                cell.textLabel.text = @"Satış Analiz Onayları";
                cell.imageView.image = [UIImage imageNamed:@"sharePointOnay.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 3:
                cell.textLabel.text = @"Başka Kullanıcı ile Giriş";
                cell.imageView.image = [UIImage imageNamed:@"profilim_mavi.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 4:
                cell.textLabel.text = @"E-Satış";
                cell.imageView.image  = [UIImage imageNamed:@"chart_icon_mavi.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 5:
                cell.textLabel.text = @"Efes Pilsen Reklamlar";
                cell.imageView.image = [UIImage imageNamed:@"efesLogo_mavi.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 6:
                cell.textLabel.text = @"Temsilcilerim";
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.imageView.image = [UIImage imageNamed:@"temsilcim_nerede.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                break;
            case 7:
                cell.textLabel.text = @"Ziyaret Planı";
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.imageView.image = [UIImage imageNamed:@"ziyaret_plani.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"";
                break;
            case 8:
                cell.textLabel.text = @"Masraf Raporu";
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.imageView.image = [UIImage imageNamed:@"masraf_yeri.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"";
                break;
            case 9:
                cell.textLabel.text = @"Kampanyalar";
                cell.imageView.image = [UIImage imageNamed:@""];
                cell.imageView.image = [UIImage imageNamed:@"kampanyalar.png"];
                cell.selectionStyle = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

-(void)viewSharePoint{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ma.efesintranet.com"]];
    
    //    CSSharePointSafariViewController *sharePointViewController = [[CSSharePointSafariViewController alloc] init];
    //    [[self navigationController] pushViewController:sharePointViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    if (section == 1) {
        switch (row) {
            case 0:
                [self viewSales];
                break;
            case 1:
                [self viewConfirmations];
                break;
            case 2:
                [self viewSharePoint];
                break;
            case 3:
                [self viewConnectWithOtherMYK];
                break;
            case 4:
                [self viewESatisReports];
                break;
            case 5:
                [self viewEfesPilsenCommercials];
                break;
            case 6:
                [self viewSalesRepresentative];
                break;
            case 7:
                [self setVisitPlan];
                break;
            case 8:
                [self viewExpenseReportFromBW];
                break;
            case 9:
                [self viewCampaigns];
                break;
            default:
                break;
        }
    }
    
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
