//
//  CSDetailSalesRepresentativeViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 20.05.2013.
//
//

#import "CSDetailSalesRepresentativeViewController.h"

@interface CSDetailSalesRepresentativeViewController ()

@end

@implementation CSDetailSalesRepresentativeViewController
@synthesize mapView, routeLine, routeLineView;

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
    
    _routeViews = [[NSMutableDictionary alloc] init];
    NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:detailCustomerRepresentative.count];
    for(int i = 0; i < detailCustomerRepresentative.count; i++)
	{
		// break the string down even further to latitude and longitude fields.
		        
        CLLocationCoordinate2D coordinate = [[[detailCustomerRepresentative objectAtIndex:i] locationCoordinate] coordinate];
		
		CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
		[points addObject:currentLocation];
	}
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:mapView];
	[mapView setDelegate:self];
    
    // first create the route annotation, so it does not draw on top of the other annotations. 
	CSRouteAnnotation* routeAnnotation = [[CSRouteAnnotation alloc] initWithPoints:points];
	[mapView addAnnotation:routeAnnotation];
    
    // create the start annotation and add it to the array
	startPoint = [[CSMapAnnotation alloc] initWithCoordinate:[[[detailCustomerRepresentative objectAtIndex:0]
                                                               locationCoordinate] coordinate]
                                              annotationType:CSMapAnnotationTypeStart
                                                       title:@"Start Point"];
	[mapView addAnnotation:startPoint];
    
    NSUInteger count = [detailCustomerRepresentative count];
    // create the end annotation and add it to the array
	endPoint = [[CSMapAnnotation alloc] initWithCoordinate:[[[detailCustomerRepresentative objectAtIndex:count-1]
                                                             locationCoordinate] coordinate]
                                            annotationType:CSMapAnnotationTypeEnd
                                                     title:@"End Point"];
	[mapView addAnnotation:endPoint];
    
    [self addObserver:self.mapView
		   forKeyPath:@"region"
			  options:0
			  context:nil];
    
    for (int i=0; i<detailCustomerRepresentative.count;i++)
    {
        CLLocationCoordinate2D coordinate = [[[detailCustomerRepresentative objectAtIndex:i] locationCoordinate] coordinate];
        NSString *title = [[NSString alloc] init];
        title = [[detailCustomerRepresentative objectAtIndex:i]name2 ];
        [mapView addAnnotation:[[CSMapAnnotation alloc] initWithCoordinate:[[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]coordinate]
                                                             annotationType:CSMapAnnotationTypeImage
                                                                      title:title]];
    }
//    [mapView setDelegate:self];
    
    [mapView setRegion:routeAnnotation.region];
    
//    locationManager = [[CLLocationManager alloc] init];
//    [locationManager startUpdatingLocation];
//    [locationManager setDelegate:self];
//    [locationManager setDistanceFilter:25];
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    

    
//    for(CSSalesRepresentative *tempSalesRepresentative in detailCustomerRepresentative){
//        
//        [self->mapView addAnnotation:tempSalesRepresentative.locationCoordinate];
//    }
//    [mapView reloadInputViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
	self.mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithArray:(NSMutableArray *)customerItem anSelectedCustomer:(CSSalesRepresentative *)selectedCustomer
{
    self = [super init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self = [super initWithNibName:@"CSDetailSalesRepresentativeViewController_Ipad" bundle:nil];
    }
    
    [[self navigationItem]setTitle:[selectedCustomer name2]];
    
    if (self) {
        detailCustomerRepresentative = [[NSMutableArray alloc] init];
        
        NSMutableArray *customerNumbers = [[NSMutableArray alloc] init];
        NSMutableArray *customerNames = [[NSMutableArray alloc] init];
        NSMutableArray *xcor = [[NSMutableArray alloc] init];
        NSMutableArray *ycor = [[NSMutableArray alloc] init];
        NSMutableArray *tarih = [[NSMutableArray alloc] init];
        NSMutableArray *saat  = [[NSMutableArray alloc]init];
        
        CSMapPoint *tempPoint;
        CSSalesRepresentative *tempSalesRepresentative;
        
        customerNumbers = [ABHXMLHelper getValuesWithTag:@"KUNNR" fromEnvelope:customerItem];
        customerNames = [ABHXMLHelper getValuesWithTag:@"NAME2" fromEnvelope:customerItem];
        xcor = [ABHXMLHelper getValuesWithTag:@"XCOOR" fromEnvelope:customerItem];
        ycor = [ABHXMLHelper getValuesWithTag:@"YCOOR" fromEnvelope:customerItem];
        tarih = [ABHXMLHelper getValuesWithTag:@"TARIH" fromEnvelope:customerItem];
        saat = [ABHXMLHelper getValuesWithTag:@"SAAT" fromEnvelope:customerItem];
        
        for (int sayac = 0; sayac<[customerNumbers count]; sayac++)
        {
            tempSalesRepresentative = [[CSSalesRepresentative alloc] init];
            
            [tempSalesRepresentative setKunnr:[customerNumbers objectAtIndex:sayac ]];
            [tempSalesRepresentative setName2:[customerNames objectAtIndex:sayac ]];
            [tempSalesRepresentative setTarih:[tarih objectAtIndex:sayac]];
            [tempSalesRepresentative setSaat:[saat objectAtIndex:sayac]];
            
            tempPoint = [[CSMapPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[ycor objectAtIndex:sayac] doubleValue], [[xcor objectAtIndex:sayac] doubleValue]) title:[tempSalesRepresentative name2]];
            [tempSalesRepresentative setLocationCoordinate:tempPoint];
            [tempPoint setPngName:[self getAnnotationPngNameFromCustomer:tempSalesRepresentative]];
            
            if ([tempSalesRepresentative.kunnr isEqualToString:selectedCustomer.kunnr]) {
                [detailCustomerRepresentative addObject:tempSalesRepresentative];
                
            }
        }

        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"saat" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [detailCustomerRepresentative sortUsingDescriptors:sortDescriptors];
    }

//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[detailCustomerRepresentative objectAtIndex:1] locationCoordinate] coordinate], 6500, 6500);
//    
//    [mapView setRegion:region animated:YES];
    
    return self;
    }
- (NSString*) getAnnotationPngNameFromCustomer:(CSSalesRepresentative *)activeCustomer{
    
    return@"beerIcon.png";
}
#pragma mark - Location Delegation Methods
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    
//    NSLog(@"newlocation %@", newLocation);
//    CSMapPoint *tempPoint = [[CSMapPoint alloc] initWithCoordinate:newLocation.coordinate title:@"Ben"];
//    
//    [user setLocation:tempPoint];
//    
//    if ([detailCustomerRepresentative count] > 0) {
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[[detailCustomerRepresentative objectAtIndex:0] locationCoordinate] coordinate], 4000, 4000);
//        [mapView setRegion:region animated:YES];
//    }
//    
//    
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location error");
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	regionChanging = YES;
	
	if(animated){
		isAnimating = YES;
		[NSThread detachNewThreadSelector: @selector(launchTransformTimerFromThread)
								 toTarget:self
							   withObject:nil];
	}
	
	UIView *viewAnnotationStart = [self.mapView viewForAnnotation:startPoint];
	UIView *viewAnnotationEnd = [self.mapView viewForAnnotation:endPoint];
    
	oldDistance = viewAnnotationStart.frame.origin.x - viewAnnotationEnd.frame.origin.x;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	regionChanging = NO;
	isAnimating = NO;
	lastScale = 1.0f;
    
	// re-enable and re-poosition the route display.
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteAnnotationView* routeView = [_routeViews objectForKey:key];
		routeView.transform = transform;
        
		[routeView regionChanged];
	}

}

-(void)launchTransformTimerFromThread
{
	//this function needs tweaking, sometimes a little flickering when doubletapping.
	
	[NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
	
	NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	
	while (isAnimating && [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:loopUntil])
		loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
	
}

-(void)timerMethod
{
	if(isAnimating)
		[self scaleRoutes];
}

-(void)scaleRoutes
{
	float scale=1.0f;
	
	if(regionChanging){
		
		UIView *viewAnnotationStart = [self.mapView viewForAnnotation:startPoint];
		UIView *viewAnnotationEnd = [self.mapView viewForAnnotation:endPoint];
		float newDistance = viewAnnotationStart.frame.origin.x - viewAnnotationEnd.frame.origin.x;
		
		scale = newDistance/oldDistance;
		
		if(scale!=1.0f && scale != lastScale){
			CGAffineTransform transform = CGAffineTransformMakeScale(scale,scale);
            
			for(NSObject* key in [_routeViews allKeys])
			{
				CSRouteAnnotationView* routeView = [_routeViews objectForKey:key];
				routeView.transform = transform;
			}
			
			lastScale = scale;
		} 
	}
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
	for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteAnnotationView* routeView = [_routeViews objectForKey:key];
		[routeView.superview sendSubviewToBack:routeView];
	}
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* annotationView = nil;
	
    
	if([annotation isKindOfClass:[CSMapAnnotation class]])
	{
		// determine the type of annotation, and produce the correct type of annotation view for it.
		CSMapAnnotation* csAnnotation = (CSMapAnnotation*)annotation;
		if(csAnnotation.annotationType == CSMapAnnotationTypeStart ||
		   csAnnotation.annotationType == CSMapAnnotationTypeEnd)
		{
			NSString* identifier = @"Pin";
			MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			            
			if(nil == pin)
			{
				pin = [[MKPinAnnotationView alloc] initWithAnnotation:csAnnotation reuseIdentifier:identifier];
			}
			
			[pin setPinColor:(csAnnotation.annotationType == CSMapAnnotationTypeEnd) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen];
        
			annotationView = pin;
			annotationView.hidden = YES;
		}
//		else if(csAnnotation.annotationType == CSMapAnnotationTypeImage)
//		{
//			NSString* identifier = @"Image";
//			
//			MKAnnotationView* imageAnnotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//			if(nil == imageAnnotationView)
//			{
//				imageAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//			}
//            
//			[imageAnnotationView setImage:[UIImage imageNamed:@"loper.png"]];
//            
//			annotationView = imageAnnotationView;
//			[annotationView setCanShowCallout:YES];
//            
//		}
		
		//[annotationView setEnabled:YES];
	}
	
	else if([annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteAnnotationView* routeView = [[CSRouteAnnotationView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
            
			routeView.annotation = routeAnnotation;
			routeView.mapView = mapView;
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = routeView;
		}
	}
	
	return annotationView;
    //burayi sabit stringle yapcaz
}

@end
