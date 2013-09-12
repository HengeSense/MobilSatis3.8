//
//  MAQueryDelegate.h
//  MAKit
//
//  Created by Biao Hua on 3/15/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAQueryDataTable;

/** 
 @ingroup MAQuery
 @brief Protocol of query used to retrieve chart data. 
 */
@protocol MAQueryDelegate <NSObject>

/**	
 @brief Executes the query and returns the query result. 
 
 @param queryName query to be asked
 @param args arguments for the query
 @returns id<MAQueryDataTable> object. If queryName is not defined, nil will be returned.
 */

-(id<MAQueryDataTable>)executeQuery:(NSString*)queryName withArgument:(NSDictionary*)args;

@end
