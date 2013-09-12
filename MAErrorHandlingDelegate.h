//
//  MAErrorHandlerDelegate.h
//  MAKit
//
//  Created by Steven Xia on 9/15/11.
//  Copyright 2011 Sybase Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAError;

@protocol MAErrorHandlingDelegate <NSObject>

/**	
 @brief The MAKit Error Handler delegate. MAKit will call the delegate when runtime error is detected. 
 
 @param error the error object that contains error information
 */

-(void)handleError:(MAError*)error;

@end
