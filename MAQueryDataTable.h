//
//  MADataTable.h
//  MAKit
//
//  Created by Biao Hua on 3/15/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 @ingroup MAQuery
 @brief Protocol that retrieves data for chart rendering
 
*/
@protocol MAQueryDataTable <NSObject>

@optional 
/**
 * Whether data in this table is already sorted for the chart
 */
@property(nonatomic) BOOL sorted;

@required
/**	
 @brief Get column number in the data table
 @returns column count
 */
-(int)getColumnCount;

/**	
 @brief Get row number in the data table
 @returns row count
 */
-(int)getRows;

/**	
 @brief get data by column name and row index 
 
 @param colName requested column name
 @param rowIndex row index in the data table
 @returns data of assigned column. If the column or rowIndex doesn't exist, nil will be returned.
 */
-(id)getData:(NSString*)colName atIndex:(int)rowIndex;

@end
