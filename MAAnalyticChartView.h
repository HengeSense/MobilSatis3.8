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
//  MAAnalyticChartView.h
//  MAKit
//
//  Created by Zhang Jie on 9/2/11.
//  Copyright 2011 Sybase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAChartViewDelegate.h"
#import "MAChartViewDataSource.h"
#import "MAChartTheme.h"
#import "MADashboardTheme.h"
#import "MAQueryDelegate.h"
#import "MAChartView.h"
#import "MAAnalyticChartViewDelegate.h"

@protocol MAErrorHandlingDelegate;

@protocol MAQueryDataSource;

@interface MAAnalyticChartView : UIView<MAChartViewDelegate, MAChartViewDataSource>
{
    
}

#pragma mark - Properties

/*! Meta data content string
 */
@property(nonatomic, copy) NSString *metaDataString;

/*! The object that acts as the data source of the receiving analytic chart view.
 */
@property(nonatomic, retain) id<MAQueryDelegate> dataSource;

/**
 The object that acts as the delegate of the receiving analytic chart view.
 */
@property(nonatomic, assign) id<MAAnalyticChartViewDelegate> delegate;

/*! The object that provides the theme of the receiving analytic chart view
 */
@property(nonatomic, retain) id<MAChartTheme, MADashboardTheme> theme;

/** 
 The object that acts as the error handler of the receiving analytic chart view.
 */
@property(nonatomic, retain) id<MAErrorHandlingDelegate> errorHandler;

/**
 A string serves as the identifier to the chart view if necessary.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 A value that determines whether the analytic chart view supports content range selection.
 
 The default is MARangeSelectorBehaviourAuto.  
 */
@property(nonatomic) MARangeSelectorBehavior contentRangeSelectorBehavior;

/**
 A Boolean value that determines whether chart view is in thumbnail mode.
 
 The default is NO.
 */
@property(nonatomic) BOOL isThumbnailMode;

/**
 A Boolean value that determines whether chart view title is hidden.
 
 The default is NO.
 */
@property(nonatomic) BOOL isTitleHidden;

/**
 Edge insets (Padding) around chart view
 */
@property(nonatomic) UIEdgeInsets chartViewEdgeInsets;

/**
 Total level counts in the drill down path, including the top level chart.  If no drill down defined, returns 1.
 */
@property(nonatomic, readonly) NSUInteger drillDownPathLevelCount;

/**
 Current level index in the drill down path. Top level == 0.
 */
@property(nonatomic, readonly) NSUInteger currentLevelInDrillDownPath;

/**
 Drill down path titles of the current chart view.  An array of string instances.
 */
@property(nonatomic, readonly) NSArray *drillDownPathTitles;

/**
 Count of category hierarchies (for example, semantic zooming, treemap category grouping) of the chart view in the current drill down level; if no semantic zooming defined, returns 1.
 */
@property(nonatomic, readonly) NSUInteger categoryHierarchyCount;

/**
 Current level index in the category hierarchy of the chart view. Bottom level (most detailed level) == 0.
 */
@property(nonatomic, readonly) NSUInteger currentLevelInCategoryHierarchy;

/**
 Category titles for all cateogry hierarchy levels of the current chart view.  An array of string instances.
 */
@property(nonatomic, readonly) NSArray *categoryHierarchyTitles;

/**
 Returns a boolean value that determines whether chart view has what if scenario
 */
@property(nonatomic, readonly) BOOL hasWhatIfScenario;

/**
 Returns a boolean value that determines whether chart is a datagrid type
 */
@property(nonatomic, readonly) BOOL isDataGridChart;

#pragma mark - Methods


/**
 @brief Refreshs the chart view.  
 
 Call this method to reload data synchronously from the data source and reconstruct the chart view, including subviews and sublayers.
 */
- (void)refreshSync;

/**
 @brief Refreshs the chart view.  
 
 Call this method to reload data from the data source and reconstruct the chart view, including subviews and sublayers.
 */
- (void)refresh;

/**
 @brief Drills up to the specified level in chart. 
 
 Call this method to drill up one level (return to the previous level) in the drill down path, if applicable.
 @param level The number specifying the level to drill up to
 */
- (void)drillUpToLevel:(NSUInteger)level;

/**
 @brief Changes hierarchy level in chart. (Zoom in/Zoom out)
 
 Call this method to change hierarchy level, if applicable.  If level is invalid, it will be ignored.
 @param level The number specifying the hierarchy level
*/
- (void)changeHierarchyLevel:(NSUInteger)level;

/**
 @brief Toggles what-if panel between show and hidden states, if applicable.
 
 No panel will be shown if there is no what-if scenario defined in the metadata file.
 @return A boolean value indicating the visibility of the what-if panel is visible after the toggle is done.
 */
- (BOOL)toggleWhatIfPanel;

/**
 @brief Toggles between chart itself and data table, if applicable.
 
 */
- (void)toggleTable;

/**
 @brief show email panel with the chart picture.
 
 */
- (void)sharedByEmail:(UIViewController*)controller;

@end
