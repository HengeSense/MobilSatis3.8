/*
 
 Copyright (c) Sybase, Inc. 2011  All rights reserved.                                   
 
 In addition to the license terms set out in the Sybase License Agreement for 
 the Sybase Unwired Platform ("Program"), the following additional or different 
 rights and accompanying obligations and restrictions shall apply to the source 
 code in this file ("Code").  Sybase grants you a limited, non-exclusive, 
 non-transferable, revocable license to use, reproduce, and modify the Code 
 solely for purposes of (i) maintaining the Code as reference material to better
 understand the operation of the Program, and (ii) development and testing of 
 applications created in connection with your licensed use of the Program.  
 The Code may not be transferred, sold, assigned, sublicensed or otherwise 
 conveyed (whether by operation of law or otherwise) to another party without 
 Sybase's prior written consent.  The following provisions shall apply to any 
 modifications you make to the Code: (i) Sybase will not provide any maintenance
 or support for modified Code or problems that result from use of modified Code;
 (ii) Sybase expressly disclaims any warranties and conditions, express or 
 implied, relating to modified Code or any problems that result from use of the 
 modified Code; (iii) SYBASE SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE RELATING
 TO MODIFICATIONS MADE TO THE CODE OR FOR ANY DAMAGES RESULTING FROM USE OF THE 
 MODIFIED CODE, INCLUDING, WITHOUT LIMITATION, ANY INACCURACY OF DATA, LOSS OF 
 PROFITS OR DIRECT, INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, EVEN
 IF SYBASE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES; (iv) you agree 
 to indemnify, hold harmless, and defend Sybase from and against any claims or 
 lawsuits, including attorney's fees, that arise from or are related to the 
 modified Code or from use of the modified Code. 
 
 */

//
//  MAView.h
//  MAKit
//
//  Created by Zhang Jie on 12/6/10.
//  Copyright 2010 Sybase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MADashboardViewDelegate.h"
#import "MADashboardViewDataSource.h"
#import "MAChartViewDelegate.h"


@protocol MAChartTheme;
@protocol MADashboardTheme;
@protocol MAQueryDelegate;
@protocol MAErrorHandlingDelegate;
@protocol MAViewDelegate;

/*! \defgroup PROTOCOLS PROTOCOLS
 *  \defgroup Dashboard Dashboard
 *  \defgroup Chart Chart
 */


/*! \brief View class that contains main functions of MAKit.
 *
 * It accepts MAKit meta data configurations and renders a dashboard or a single chart with analytic features based on the configurations. 
 *
 *	\section codeexample Code Example
 *	\code
 MAView *view = [[MAViewController alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
 view.metaDataPath = [[NSBundle mainBundle] pathForResource:@"MAMeta" ofType:@"xml"];
 view.theme = [[[MAKitTheme_WelterWeight alloc] init] autorelease];
 ...
 [view refresh];
 *	\endcode
 */
@interface MAView : UIView <MADashboardViewDelegate, MADashboardViewDataSource, MAChartViewDelegate>
{

}

/*! Meta data file path
 */
@property(nonatomic, retain) NSString *metaDataPath;

/*! Theme of charts and dashboard in the view.
 */
@property(nonatomic, retain) id<MAChartTheme, MADashboardTheme> theme;

/*! Data source object
 */
@property(nonatomic, retain) id<MAQueryDelegate> dataSource;

/*! View controller
 */
@property(nonatomic, assign) UIViewController *controller;

/*! The error handler delegate
 */
@property (nonatomic, retain) id<MAErrorHandlingDelegate> errorHandler;

/**
 The object that acts as the delegate of the receiving dahboard view.
 @discussion The delegate is not retained 
 */
@property(nonatomic, assign) id<MAViewDelegate> delegate;

/*! @brief Refresh the content
 */
- (void)refresh;

@end
