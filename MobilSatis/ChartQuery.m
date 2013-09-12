//
//  ChartQueryClass.m
//  MAKitSample
//
//  Created by Abdul Azeez on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChartQuery.h"
#import "ChartDataTable.h"


@implementation ChartQuery
@synthesize report1, report2, report3, report1Text, report2Text, report3Text, header1, header2, header3;
#pragma mark -
#pragma mark MAQueryDelegate method

-(id<MAQueryDataTable>)executeQuery:(NSString*)queryName withArgument:(NSDictionary*)args {
    
    ChartDataTable *dataTable = [[ChartDataTable alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if ([queryName isEqualToString:@"MYKSales"]) {
        
        for (int sayac = 0; sayac<report1.count; sayac++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/yyyy"];
            [formatter setLocale:[NSLocale systemLocale]];
            NSDate *date = [formatter dateFromString:[report1Text objectAtIndex:sayac]];
            [dict setObject:date forKey:@"Month"];
            
            [dict setObject:header1 forKey:@"Type"];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[report1 objectAtIndex:sayac]];
            
            [dict setObject:myNumber forKey:@"SalesAmount"];
            [returnArray addObject:dict];
        }
        
        for (int sayac = 0; sayac<report2.count; sayac++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/yyyy"];
            [formatter setLocale:[NSLocale systemLocale]];
            NSDate *date = [formatter dateFromString:[report1Text objectAtIndex:sayac]];
            [dict setObject:date forKey:@"Month"];
            
            [dict setObject:header2 forKey:@"Type"];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[report2 objectAtIndex:sayac]];
            
            [dict setObject:myNumber forKey:@"SalesAmount"];
            [returnArray addObject:dict];
        }
        
        for (int sayac = 0; sayac<report3.count; sayac++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/yyyy"];
            [formatter setLocale:[NSLocale systemLocale]];
            NSDate *date = [formatter dateFromString:[report1Text objectAtIndex:sayac]];
            [dict setObject:date forKey:@"Month"];
            
            [dict setObject:header3 forKey:@"Type"];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[report3 objectAtIndex:sayac]];
            
            [dict setObject:myNumber forKey:@"SalesAmount"];
            [returnArray addObject:dict];
        }
        
    }
    
    if ([queryName isEqualToString:@"CustomerSales"]) {
        for (int sayac = 0; sayac<report1.count; sayac++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/yyyy"];
            [formatter setLocale:[NSLocale systemLocale]];
            NSDate *date = [formatter dateFromString:[report1Text objectAtIndex:sayac]];
            [dict setObject:date forKey:@"Month"];
            

            NSString *str = [[[report1 objectAtIndex:sayac] componentsSeparatedByString:@"."] objectAtIndex:0];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:str];
            
            [dict setObject:myNumber forKey:@"SalesAmount"];
            [returnArray addObject:dict];
        }
        
    }
    dataTable.tabularData = returnArray;
    return dataTable;
}

@end