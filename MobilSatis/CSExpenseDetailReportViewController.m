//
//  CSExpenseDetailReportViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 05.07.2013.
//
//

#import "CSExpenseDetailReportViewController.h"

@interface CSExpenseDetailReportViewController ()

@end

@implementation CSExpenseDetailReportViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithArray:(NSMutableArray *)table andNibName:(NSString *)nibName andDescription:(NSString *)description
{
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    title = description;
    expensesReport = [[NSMutableArray alloc] init];
    expensesReport = table;
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;

    [[self navigationItem] setTitle:title];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)getMonths:(NSIndexPath*)index{
    
    NSString *desc;
    
    int i = index.row;
    
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"001"]) {
        desc = @"Ocak";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"002"]) {
        desc = @"Şubat";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"003"]) {
        desc = @"Mart";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"004"]) {
        desc = @"Nisan";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"005"]) {
        desc = @"Mayıs";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"006"]) {
        desc = @"Haziran";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"007"]) {
        desc = @"Temmuz";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"008"]) {
        desc = @"Ağustos";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"009"]) {
        desc = @"Eylül";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"010"]) {
        desc = @"Ekim";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"011"]) {
        desc = @"Kasım";
    }
    if ([[[expensesReport objectAtIndex:index.row] objectAtIndex:0] isEqualToString:@"012"]) {
        desc = @"Aralık";
    }
    
    return desc;
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [expensesReport count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];
    
    NSString *desc = [self getMonths:indexPath];
    
    NSString *text = [NSString stringWithFormat:@"%@ - %@ TL",desc,[[expensesReport objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    [[cell textLabel]setText:text];
    [[cell textLabel]setFont:[UIFont boldSystemFontOfSize:15]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([[[expensesReport objectAtIndex:indexPath.row ] objectAtIndex:2] isEqualToString:@"010"]) {
        [[cell detailTextLabel] setText: @"Fiili Gider"];
    }
    else
    {
        [[cell detailTextLabel] setText: @"Bütçe"];
    }
    [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:13]];

    return cell;
}

@end
