//
//  ChartDataTable.m
//  MAKitSample
//
//  Created by Abdul Azeez on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChartDataTable.h"


@implementation ChartDataTable
@synthesize tabularData;

#pragma mark -
#pragma mark MAQueryDataTable Delegate methods

-(int)getColumnCount {
    
    if(self.tabularData != nil && [self.tabularData count] > 0)
    {
        NSDictionary* row = (NSDictionary*)[self.tabularData objectAtIndex:0];
        return [row count];
    }
    else
    {
        return 0;
    }
    
}


-(int)getRows {
    if (self.tabularData != nil) {
        return [self.tabularData count];
    }
    else {
        return 0;
    }
}


-(id)getData:(NSString*)colName atIndex:(int)rowIndex {
    if(self.tabularData != nil && [self.tabularData count] > rowIndex)
    {
        NSDictionary* row = (NSDictionary*)[self.tabularData objectAtIndex:rowIndex];
        return [row objectForKey:colName];
    }
    else
    {
        return nil;
    }
    
}

#pragma mark -
-(void) dealloc {
//    [super dealloc];
}

//- (id)initWithOptions {
//    self = [super init];
//    
//    if (self) {
//        
//    }
//    return self;
//}
//
//#pragma mark -
//#pragma mark MAQueryDataTable Delegate methods
//
//-(int)getColumnCount {
//    
//    if(self.tabularData != nil && [self.tabularData count] > 0)
//    {
//        NSDictionary* row = (NSDictionary*)[self.tabularData objectAtIndex:0];
//        return [row count];
//    }
//    else
//    {
//        return 0;
//    }
//    
//}
//
//
//-(int)getRows {
//    if (self.tabularData != nil) {
//        return [self.tabularData count];
//    }
//    else {
//        return 0;
//    }
//}
//
//
//-(id)getData:(NSString*)colName atIndex:(int)rowIndex {
//    if(self.tabularData != nil && [self.tabularData count] > rowIndex)
//    {
//        NSDictionary* row = (NSDictionary*)[self.tabularData objectAtIndex:rowIndex];
//        return [row objectForKey:colName];
//    }
//    else
//    {
//        return nil;
//    }
//    
//}
//
//#pragma mark -
//-(void) dealloc {
//}

@end
