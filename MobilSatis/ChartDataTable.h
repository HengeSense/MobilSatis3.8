//
//  ChartDataTable.h
//  MAKitSample
//
//  Created by Abdul Azeez on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAKit.h"

@interface ChartDataTable : NSObject<MAQueryDataTable> {
    
}
@property (nonatomic,retain) NSArray *tabularData;

- (id)initWithOptions;
@end
