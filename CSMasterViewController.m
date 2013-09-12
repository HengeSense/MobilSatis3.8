 //
//  EBMasterViewController.m
//  EfesBayi
//
//  Created by alp keser on 4/11/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "CSMasterViewController.h"

@interface CSMasterViewController ()
@property (strong,nonatomic) NSArray *menu;
@end

@implementation CSMasterViewController
@synthesize menu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUser:(CSUser *)myUser{
    userInfo = myUser;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menu = [NSArray arrayWithObjects:@"Profilim", @"Müşterilerim",@"Neredeyim", nil];
    
    UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background-01.png"]];
    self.view.backgroundColor = color;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    
    [[self navigationItem] setTitle:@"Menü"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSAppDelegate *appDelegate = (CSAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSUInteger row = indexPath.row;
    [appDelegate.splitViewController viewWillDisappear:YES];
	NSMutableArray *viewControllerArray=[[NSMutableArray alloc] initWithArray:[[appDelegate.splitViewController.viewControllers objectAtIndex:1] viewControllers]];
	[viewControllerArray removeLastObject];
	
    
    if (row == 0) {
		profileViewController = [[CSProfileViewController alloc] initWithUser:userInfo];
		[viewControllerArray addObject:profileViewController];
	}
	
    if (row == 1) {
		dealerListViewController = [[CSDealerListViewController alloc] initWithUser:userInfo];
		[viewControllerArray addObject:dealerListViewController];
    }
    
    if (row == 2) {
        locationViewController = [[CSLoctionHandlerViewController alloc] initWithUser:userInfo];
		[viewControllerArray addObject:locationViewController];
    }
    
	[[appDelegate.splitViewController.viewControllers objectAtIndex:1] setViewControllers:viewControllerArray animated:NO];
	
	
	[appDelegate.splitViewController viewWillAppear:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // This will create a "invisible" footer
    
    return 0.01f;
    
}

@end
