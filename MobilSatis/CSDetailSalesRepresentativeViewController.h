//
//  CSDetailSalesRepresentativeViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 20.05.2013.
//
//

#import "CSBaseViewController.h"
#import "CSSalesRepresentative.h"
#import <CoreLocation/CoreLocation.h>
#import "CSRouteAnnotation.h"
#import "CSRouteAnnotationView.h"
#import "CSMapAnnotation.h"
#import <MapKit/MapKit.h>
//#import <Foundation/Foundation.h>
//#import "RegexKitLite.h"

@class CSWebDetailsViewController;
@class CSMapAnnotation;

@interface CSDetailSalesRepresentativeViewController : CSBaseViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *detailCustomerRepresentative;
    MKMapView *mapView;
    MKPolylineView *routeLineView;
    MKPolyline *routeLine;
    UIImageView* routeView;
    UIColor* lineColor;
    
    NSArray *routes;
    
    id <MKAnnotation> startPoint;
	id <MKAnnotation> endPoint;
    /* we need to store the distance between the 2 annotation before region change */
	float oldDistance;
    
	/* store the last transform scale to avoid transforming the view with the same scale */
	float lastScale;
    
	/* we need this BOOLs to indicate what the mapView is doing */
	BOOL isAnimating;
	BOOL regionChanging;
	
	// dictionary of route views indexed by annotation
	NSMutableDictionary* _routeViews;
}

-(void) scaleRoutes;

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(id)initWithArray:(NSMutableArray *)customerItem anSelectedCustomer:(CSSalesRepresentative *)selectedCustomer;
@end
