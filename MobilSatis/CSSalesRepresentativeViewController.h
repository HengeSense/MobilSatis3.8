//
//  CSSalesRepresentativeViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 16.05.2013.
//
//

#import "CSBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CSSalesRepresentative.h"
#import "CSDetailSalesRepresentativeViewController.h"

@interface CSSalesRepresentativeViewController : CSBaseViewController < UITableViewDataSource, CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate, ABHSAPHandlerDelegate>
{
    NSString *kunnr;
    CLLocationManager *locationManager;
    MKMapView *mapView;
    NSMutableArray *distrList;
    NSString *responseBuffer;
    NSMutableArray *pickerViewList;
    NSMutableArray *salesRepresentative;
    NSMutableArray *customerItemTable;
    int selectedRow;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (void)pickerViewRowSelected:(id)sender;
@end
