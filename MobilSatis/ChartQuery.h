//
//  ChartQueryClass.h
//  MAKitSample
//
//  Created by Abdul Azeez on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAKit.h"

@interface ChartQuery : NSObject<MAQueryDelegate> 
@property (nonatomic, retain) NSMutableArray *report1;
@property (nonatomic, retain) NSMutableArray *report2;
@property (nonatomic, retain) NSMutableArray *report3;
@property (nonatomic, retain) NSMutableArray *report1Text;
@property (nonatomic, retain) NSMutableArray *report2Text;
@property (nonatomic, retain) NSMutableArray *report3Text;
@property (nonatomic, retain) NSString *header1;
@property (nonatomic, retain) NSString *header2;
@property (nonatomic, retain) NSString *header3;

@end
