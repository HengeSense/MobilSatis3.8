//
//  CSEfesPilsenCommercialsViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 17.02.2013.
//
//

#import "CSEfesPilsenCommercialsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CSEfesPilsenCommercialsViewController ()

@end

@implementation CSEfesPilsenCommercialsViewController
@synthesize tableView;
@synthesize streamPlayer;

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
    // Do any additional setup after loading the view from its nib.
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    
    commercialVideos = [[NSMutableArray alloc] init];
    
    [[self navigationItem] setTitle:@"Efes Pilsen Reklamlar"];
    
    [self getCommercialVideosFromCrm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCommercialVideosFromCrm
{
    [super playAnimationOnView:self.view];
    NSString *table = [NSString stringWithFormat:@"T_COMM_LOC"];
    
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    [columns addObject:@"VIDEO_NAME"];
    [columns addObject:@"VIDE_LOCATION"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword]
                         andRFCName:@"ZMOB_GET_COMM_VIDEO_LOCATION"];
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:table andColumns:columns];
    [sapHandler prepCall];
}

- (void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me
{
    NSRange range = [myResponse rangeOfString:@"item"];
    if (range.length > 0)
    {
        NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"ZMOB_T_COMM_LOC" fromEnvelope:myResponse];
        
        NSMutableArray *name = [[NSMutableArray alloc] init];
        NSMutableArray *location = [[NSMutableArray alloc] init];
        
        name = [ABHXMLHelper getValuesWithTag:@"VIDEO_NAME" fromEnvelope:[responses objectAtIndex:0]];
        location = [ABHXMLHelper getValuesWithTag:@"VIDE_LOCATION" fromEnvelope:[responses objectAtIndex:0]];
        
        if ([name count] > 0) {
            for (int sayac = 0; sayac < [name count]; sayac++) {
                
                NSString *videoName = [name objectAtIndex:sayac];
                NSString *videoLocation = [location objectAtIndex:sayac];
                
                NSArray *arr = [NSArray arrayWithObjects:videoName,videoLocation, nil];
                
                [commercialVideos addObject:arr];
                
            }
        }
        
        [tableView reloadData];
        [super stopAnimationOnView];
    }
    else
    {
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [commercialVideos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    int row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];

    cell.textLabel.text = [[commercialVideos objectAtIndex:row]objectAtIndex:0];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    NSURL *url;

    url = [[NSURL alloc] initWithString:[[commercialVideos objectAtIndex:row] objectAtIndex:1]];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [[movieController view] setFrame: [self.view bounds]];
    [movieController.moviePlayer play];

    [[self navigationController] presentModalViewController:movieController animated:NO];
    
}

@end
