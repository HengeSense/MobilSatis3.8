//
//  CSSalesRepresentativeViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 16.05.2013.
//
//

#import "CSSalesRepresentativeViewController.h"

@interface CSSalesRepresentativeViewController ()

@end

@implementation CSSalesRepresentativeViewController
@synthesize tableView, pickerView, mapView;

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
    NSString *nibName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        nibName = @"CSSalesRepresentativeViewController_Ipad";
    }else{
        nibName = @"CSSalesRepresentativeViewController";
    }
    
    kunnr = myUser.username;
    
    self = [super initWithNibName:nibName bundle:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    
    pickerViewList = [[NSMutableArray alloc] init];
    salesRepresentative =[[NSMutableArray alloc] init];
    customerItemTable = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:25];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [tableView setHidden:YES];
    [mapView setHidden:YES];
    
    [[self navigationItem] setTitle:@"Temsilcilerim"];
    
    //    //configuring map
    //    [mapView setUserInteractionEnabled:YES];
    //    [mapView setShowsUserLocation:YES];
    
    [self getSalesManagementFromSap];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSalesManagementFromSap
{
    [super playAnimationOnView:self.view];
    NSString *tableName = [NSString stringWithFormat:@"T_MUDURLUK"];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"VKBUR"];
    [columns addObject:@"BEZEI"];
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getR3Destination] andSystemNumber:[ABHConnectionInfo getR3SystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_MUDURLUK"];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:kunnr];
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tableName andColumns:columns];
    [sapHandler prepCall];
    
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    if ([[me RFCNameLine] rangeOfString:@"ZMOB_GET_MUDURLUK"
                                options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
        
        if ([[responses objectAtIndex:0] isEqualToString: @"T"])
        {
            [self initSalesManagement:[ABHXMLHelper getValuesWithTag:@"VKBUR" fromEnvelope:myResponse] anDescription:[ABHXMLHelper getValuesWithTag:@"BEZEI" fromEnvelope:myResponse]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Temsilcileri görüntüleme yetkiniz yoktur." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            alert.tag = 2;
            [alert show];
        }
        
        
    }
    else if([[me RFCNameLine] rangeOfString:@"ZMOB_GET_TEMSILCI"
                                    options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        customerItemTable = [[ABHXMLHelper getValuesWithTag:@"ZMOB_S_GET_TEMSILCI" fromEnvelope:myResponse]objectAtIndex:1];
        
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_GET_TEMSILCI" fromEnvelope:myResponse];
        if ([responses count] > 0) {
            NSString *customerTable = [NSString stringWithFormat:@"%@",[responses objectAtIndex:0]];
            
            [self initSalesRepresentativeFromResponse:customerTable];
            
            if ([salesRepresentative count] > 0)
            {
                
                for(CSSalesRepresentative *tempSalesRepresentative in salesRepresentative){
                    
                    [self->mapView addAnnotation:tempSalesRepresentative.locationCoordinate];
                }
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[salesRepresentative objectAtIndex:1] locationCoordinate] coordinate], 6500, 6500);
                
                [mapView setRegion:region animated:YES];
                
                [tableView reloadData];
                [mapView reloadInputViews];
                [super stopAnimationOnView];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Etrafınızda temsilci bulunamamıştır." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles: nil];
                
                alertView.tag = 1;
                [alertView show];
                [super stopAnimationOnView];
                return;
                
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0) {
                [pickerView setHidden:NO];
                [tableView setHidden:YES];
                [mapView setHidden:YES];
                [pickerView reloadAllComponents];
            }
            break;
        case 2:
            [[self navigationController] popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)initSalesRepresentativeFromResponse:(NSString*)myResponse {
    salesRepresentative = [[NSMutableArray alloc] init];
    NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
    NSMutableArray *customerNames = [[NSMutableArray alloc] init];
    NSMutableArray *customerPhones = [[NSMutableArray alloc] init];
    NSMutableArray *xcor = [[NSMutableArray alloc] init];
    NSMutableArray *ycor = [[NSMutableArray alloc] init];
    
    CSMapPoint *tempPoint;
    CSSalesRepresentative *tempSalesRepresentative;
    
    customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:myResponse];
    customerNames   = [ABHXMLHelper getValuesWithTag:@"NAME2" fromEnvelope:myResponse];
    customerPhones  = [ABHXMLHelper getValuesWithTag:@"TELF1" fromEnvelope:myResponse];
    xcor = [ABHXMLHelper getValuesWithTag:@"XCOOR" fromEnvelope:myResponse];
    ycor = [ABHXMLHelper getValuesWithTag:@"YCOOR" fromEnvelope:myResponse];
    
    for (int sayac = 0; sayac<[customerNumbers count]; sayac++) {
        tempSalesRepresentative = [[CSSalesRepresentative alloc] init];
        
        [tempSalesRepresentative setKunnr:[customerNumbers objectAtIndex:sayac ]];
        [tempSalesRepresentative setName2:[customerNames objectAtIndex:sayac ]];
        [tempSalesRepresentative setTelf1:[customerPhones objectAtIndex:sayac]];
        
        tempPoint = [[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[ycor objectAtIndex:sayac] doubleValue], [[xcor objectAtIndex:sayac] doubleValue]) title:[NSString stringWithFormat:@"%@%@%@",  [tempSalesRepresentative name2],@" - ",[tempSalesRepresentative telf1]]];
        [tempSalesRepresentative setLocationCoordinate:tempPoint];
        [tempPoint setPngName:[self getAnnotationPngNameFromCustomer:tempSalesRepresentative]];
        
        [salesRepresentative addObject:tempSalesRepresentative];
    }
}
- (NSString*) getAnnotationPngNameFromCustomer:(CSSalesRepresentative *)activeCustomer{
    
    return@"beerIcon.png";
}
- (void)initSalesManagement:(NSArray*)itemMudurluk anDescription:(NSArray*)itemDescription{
    
    for (int i = 0; i < [itemMudurluk count]; i++) {
        NSString *mudurluk = [itemMudurluk objectAtIndex:i];
        NSString *description = [itemDescription objectAtIndex:i];
        
        NSArray *arr = [NSArray arrayWithObjects:mudurluk,description, nil];
        
        [pickerViewList addObject:arr];
    }
    
    if ([pickerViewList count] > 0)
    {
        [pickerView setHidden:NO];
        [tableView setHidden:YES];
        [mapView setHidden:YES];
        [pickerView reloadAllComponents];
        [super stopAnimationOnView];
        
        UIBarButtonItem *changeButton = [[UIBarButtonItem alloc] initWithTitle:@"Seç" style:UIBarButtonItemStyleBordered target:self action:@selector(changeButtonClicked)];
        [[self navigationItem] setRightBarButtonItem:changeButton];
    }
}


- (void)changeButtonClicked {
    if (![super isAnimationRunning]) {
        if ([[[[self navigationItem] rightBarButtonItem] title] isEqualToString:@"Seç"]) {
            [self pickerViewRowSelected:nil];
            [[[self navigationItem] rightBarButtonItem] setTitle:@"Değiştir"];
            [[self pickerView] setHidden:YES];
            [[self mapView] setHidden:NO];
            [[self tableView] setHidden:NO];
        }
        else
        {
            [[[self navigationItem] rightBarButtonItem] setTitle:@"Seç"];
            [[self pickerView] setHidden:NO];
            [[self tableView] setHidden:YES];
            [[self mapView] setHidden:YES];
        }
    }
}

- (void) pickerViewRowSelected:(id)sender{
    [super playAnimationOnView:self.view];
    NSString *headerTable = [NSString stringWithFormat:@"T_TEMSHDR"];
    NSString *itemTable = [NSString stringWithFormat:@"T_TEMSITM"];
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"KUNNR"];
    [columns addObject:@"NAME2"];
    [columns addObject:@"TELF1"];
    [columns addObject:@"XCOOR"];
    [columns addObject:@"YCOOR"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getR3HostName] andClient:[ABHConnectionInfo getR3Client] andDestination:[ABHConnectionInfo getR3Destination] andSystemNumber:[ABHConnectionInfo getR3SystemNumber] andUserId:[ABHConnectionInfo getR3UserId] andPassword:[ABHConnectionInfo getR3Password] andRFCName:@"ZMOB_GET_TEMSILCI"];
    [sapHandler addImportWithKey:@"I_VKBUR" andValue:[[pickerViewList objectAtIndex:selectedRow] objectAtIndex:0]];
    [sapHandler addImportWithKey:@"I_MYK" andValue:kunnr];
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:headerTable andColumns:columns];
    [sapHandler addTableWithName:itemTable andColumns:columns];
    [sapHandler prepCall];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [salesRepresentative count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    CSSalesRepresentative *temp = [salesRepresentative objectAtIndex:indexPath.row];
    [[cell textLabel]setText:[NSString stringWithFormat:@"%@%@%@",  [temp name2],@" - ",[temp telf1]]];
    [[cell detailTextLabel] setText:temp.kunnr];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
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
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[salesRepresentative objectAtIndex:indexPath.row] locationCoordinate] coordinate], 100, 100);
        
        [mapView setRegion:region animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    CSSalesRepresentative *selectedCustomer = [salesRepresentative objectAtIndex:indexPath.row];
    
    CSDetailSalesRepresentativeViewController *detailSalesRepresentative;
    
    detailSalesRepresentative = [[CSDetailSalesRepresentativeViewController alloc] initWithArray:customerItemTable anSelectedCustomer:selectedCustomer];
    
    [[self navigationController] pushViewController:detailSalesRepresentative animated:YES];
    
    //    CSCustomerDetailViewController *customerDetailViewController;
    //
    //    if ([[selectedCustomer relationship] isEqualToString:@"04"] || [[selectedCustomer relationship] isEqualToString:@"05"])
    //        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:YES];
    //    else
    //        customerDetailViewController = [[CSCustomerDetailViewController alloc] initWithUser:[self user] andCustomer:selectedCustomer isDealer:NO];
    //
    //    [[self navigationController] pushViewController:customerDetailViewController animated:YES];
    
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

#pragma mark - Location Delegation Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"newlocation %@", newLocation);
    CSMapPoint *tempPoint = [[CSMapPoint alloc] initWithCoordinate:newLocation.coordinate title:@"Ben"];
    //for test purpose
    // tempPoint =  [tempPoint initWithCoordinate:CLLocationCoordinate2DMake([@"40.888803" doubleValue], [@"29.188903" doubleValue]) title:@"Ben"] ;
    
    [user setLocation:tempPoint];
    
    if ([salesRepresentative count] > 0) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[salesRepresentative objectAtIndex:0] locationCoordinate] coordinate], 250, 250);
        [mapView setRegion:region animated:YES];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location error");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    //    static bool justOnce = true;
    //    if (justOnce) {
    
    //        justOnce = false;
    //    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //burayi sabit stringle yapcaz
    MKAnnotationView *annotationView = nil;
    //    CSMapPoint *tempPoint;
    if ([annotation isKindOfClass:[CSMapPoint class]]) {
        //        tempPoint = annotation;
        
        NSString* identifier = @"Pin";
        MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(nil == pin)
        {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        [pin setPinColor:MKPinAnnotationColorRed];
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.rightCalloutAccessoryView = infoButton;
        pin.canShowCallout = YES;
        
        annotationView = pin;
    }
    else
    {
        return  nil;
    }
    
    //    [annotationView setImage:[UIImage imageNamed:tempPoint.pngName]];
    
    
    if ([annotation.title isEqualToString:@"Current Location"] || [annotation.title isEqualToString:@"Ben"]) {
        
        return  nil;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    BOOL check = NO;
    CSSalesRepresentative *selectedCustomer;
    for (int sayac=0; sayac<[salesRepresentative count]; sayac++) {
        if ([[NSString stringWithFormat:@"%f",[view.annotation coordinate].latitude] isEqualToString:[NSString stringWithFormat:@"%f", [[[salesRepresentative objectAtIndex:sayac ] locationCoordinate] coordinate].latitude ]] && [[NSString stringWithFormat:@"%f",[view.annotation coordinate].longitude] isEqualToString:[NSString stringWithFormat:@"%f", [[[salesRepresentative objectAtIndex:sayac ] locationCoordinate] coordinate].longitude ]]) {
            check = YES;
            selectedCustomer = [salesRepresentative objectAtIndex:sayac];
            
        }
    }
    //
    if (!check) {
        return;
    }
    
    CSDetailSalesRepresentativeViewController *detailSalesRepresentative;
    
    detailSalesRepresentative = [[CSDetailSalesRepresentativeViewController alloc] initWithArray:customerItemTable anSelectedCustomer:selectedCustomer];
    
    [[self navigationController] pushViewController:detailSalesRepresentative animated:YES];
}
@end
