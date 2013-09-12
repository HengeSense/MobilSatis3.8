//
//  CSRouteView.h
//  testMapp
//
//  Created by Craig on 8/18/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@class CSRouteViewInternal;
@class CSRouteAnnotation;
@class CSRouteAnnotationView;
// this is an internally used view to CSRouteView. The CSRouteView needs a subview that does not get clipped to always
// be positioned at the full frame size and origin of the map. This way the view can be smaller than the route, but it
// always draws in the internal subview, which is the size of the map view. 
@interface CSRouteViewInternal : UIView
{
	// route view which added this as a subview. 
	CSRouteAnnotationView* _routeView;
}
@property (nonatomic, retain) CSRouteAnnotationView* routeView;
-(UIImage *)routeImage;

@end

// annotation view that is created for display of a route. 
@interface CSRouteAnnotationView: MKAnnotationView 
{
	MKMapView* _mapView;

	CSRouteViewInternal* _internalRouteView;
}

// signal from our view controller that the map region changed. We will need to resize, recenter and 
// redraw the contents of this view when this happens. 
-(void) regionChanged;

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) CSRouteViewInternal* _internalRouteView;

-(void)setScaleWithNumber:(NSNumber*)scale;

@end
