//
//  CSRouteView.m
//  testMapp
//
//  Created by Craig on 8/18/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import "CSRouteAnnotation.h"
#import "CSRouteAnnotationView.h"


@implementation CSRouteViewInternal
@synthesize routeView = _routeView;

-(void) drawRect:(CGRect) rect
{
	CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*)self.routeView.annotation;
	
	// only draw our lines if we're not int he moddie of a transition and we 
	// acutally have some points to draw. 
	if(nil != routeAnnotation.points && routeAnnotation.points.count > 0)
	{
		CGContextRef context = UIGraphicsGetCurrentContext(); 
		
		if(nil == routeAnnotation.lineColor)
			routeAnnotation.lineColor = [UIColor colorWithRed:147.0f/255.0f green:83.0f/255.0f blue:216.0f/255.0f alpha:1.0]; // setting the property instead of the member variable will automatically reatin it.
		
		CGContextSetStrokeColorWithColor(context, routeAnnotation.lineColor.CGColor);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
		
		// Draw them with a 2.0 stroke width so they are a bit more visible.
		CGContextSetLineWidth(context, 6.0);
		CGContextSetLineCap(context, kCGLineCapRound);
		
		for(int idx = 0; idx < routeAnnotation.points.count; idx++)
		{
			CLLocation* location = [routeAnnotation.points objectAtIndex:idx];
			CGPoint point = [self.routeView.mapView convertCoordinate:location.coordinate toPointToView:self];
			
			//NSLog(@"Point: %lf, %lf", point.x, point.y);
			
			if(idx == 0)
			{
				// move to the first point
				CGContextMoveToPoint(context, point.x, point.y);
			}
			else
			{
				CGContextAddLineToPoint(context, point.x, point.y);
				CGContextStrokePath(context);
				CGContextMoveToPoint(context, point.x, point.y);				
			}	
		}
		
		CGContextStrokePath(context);
		
		
		// debug. Draw the line around our view. 
		
//		CGContextMoveToPoint(context, 0, 0);
//		CGContextAddLineToPoint(context, 0, self.frame.size.height);
//		CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
//		CGContextAddLineToPoint(context, self.frame.size.width, 0);
//		CGContextAddLineToPoint(context, 0, 0);
//		CGContextStrokePath(context);
		
	}
	

}

-(id) init
{
	self = [super init];
	self.backgroundColor = [UIColor clearColor];
	self.clipsToBounds = NO;
	
	return self;
}

-(UIImage *)routeImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

-(void) dealloc
{
	self.routeView = nil;
	
}
@end

@implementation CSRouteAnnotationView
@synthesize mapView = _mapView;
@synthesize _internalRouteView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
		self.backgroundColor = [UIColor clearColor];

		// do not clip the bounds. We need the CSRouteViewInternal to be able to render the route, regardless of where the
		// actual annotation view is displayed. 
		self.clipsToBounds = NO;
		
		// create the internal route view that does the rendering of the route. 
		_internalRouteView = [[CSRouteViewInternal alloc] init];
		_internalRouteView.routeView = self;
		_internalRouteView.alpha = 0.75;
		[self addSubview:_internalRouteView];
    }
    return self;
}

-(void) setMapView:(MKMapView*) mapView
{
	_mapView = mapView;
	
	[self regionChanged];
}

-(void) regionChanged
{
	NSLog(@"Region Changed");
	
	// move the internal route view. 
	CGPoint origin = CGPointMake(0, 0);
	origin = [_mapView convertPoint:origin toView:self];
	
	_internalRouteView.frame = CGRectMake(origin.x, origin.y, _mapView.frame.size.height, _mapView.frame.size.height);	
	[_internalRouteView setNeedsDisplay];
	
}

-(void)setScaleWithNumber:(NSNumber*)scale{

}


@end
