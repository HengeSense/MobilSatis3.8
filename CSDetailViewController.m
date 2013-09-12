//
//  EBDetailViewController.m
//  EfesBayi
//
//  Created by alp keser on 4/11/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import "CSDetailViewController.h"

@interface CSDetailViewController ()

@end

@implementation CSDetailViewController

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
    [self profileSelected];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - delegate methods

- (void)customerSelected{
    CSDealerListViewController *dealerListViewController = [[CSDealerListViewController alloc] initWithUser:user];
    
    [[self navigationController] pushViewController:dealerListViewController animated:NO];
}

- (void)profileSelected{
    CSProfileViewController *profileView = [[CSProfileViewController alloc] initWithUser:[self user]];

    [[self navigationController] pushViewController:profileView animated:NO];

}

- (void)locationSelected{
    CSLoctionHandlerViewController *locationHandler = [[CSLoctionHandlerViewController alloc] initWithUser:[self user]];

    [[self navigationController] pushViewController:locationHandler animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
