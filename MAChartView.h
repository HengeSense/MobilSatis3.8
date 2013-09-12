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
//  MAChartView.h
//
//  Created by Zhang Jie on 4/17/09.
//  Copyright 2009 Sybase Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAChartViewDataSource.h"
#import "MAChartViewDelegate.h"
#import "MAChartDataModel.h"
#import "MAChartLayerModel.h"
#import "MAChartTheme.h"

typedef enum 
{
    MARangeSelectorBehaviourAuto,    // Auto enable range selector if touch point of each chart element is too small. Disabled otherwise
    MARangeSelectorBehaviourEnabled, // Always enable range selector
    MARangeSelectorBehaviourDisabled, // Always disable range selector
} MARangeSelectorBehavior;

/** 
 *  @ingroup Chart
 *  @brief Class of a chart view
 *
 *  This class represents a chart view in the UI.  It is derived from UIView.
 */
@interface MAChartView : UIView <MAChartDataModel, MAChartLayerModel>
{
}

#pragma mark -
#pragma mark Properties

/**
 A string that serves as the identifier to the chart view if necessary.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 The object that acts as the data source of the receiving chart view.
 */
@property(nonatomic, assign) id<MAChartViewDataSource> dataSource;

/**
 The object that acts as the delegate of the receiving chart view.
 */
@property(nonatomic, assign) id<MAChartViewDelegate> delegate;

/**
 The chart model of the receiving chart view.
 */
@property(retain) id<MAChartDataModel> dataModel;

/**
 The chart layer model of the receiving chart view.
 */
@property(retain) id<MAChartLayerModel> layerModel;

/**
 The object that acts as the theme of the receiving chart view
 */
@property(nonatomic, retain) id<MAChartTheme> theme;

/**
 A Boolean value that determines whether chart view is in thumbnail mode.
 
 Default is NO.
 */
@property(nonatomic) BOOL isThumbnailMode;

/**
 A Boolean value that determines whether chart view title is hidden.
 
 Default is NO.
 */
@property(nonatomic) BOOL isTitleHidden;

/**
 A Boolean value that determines whether chart legend view is hidden.
 
 The legend will only be shown if it's applicable for the specified chart type. Default is NO.
 */
@property(nonatomic) BOOL isLegendHidden;

/**
 A Boolean value that determines whether zoom by pinch gesture is enabled.
 
 Default is YES
 */
@property(nonatomic,getter=isZoomByPinchEnabled) BOOL zoomByPinchEnabled;

/**
 A value that determines the content range selection behaviour
 
 Default is MARangeSelectorBehaviourAuto.  
 */
@property(nonatomic) MARangeSelectorBehavior contentRangeSelectorBehavior;

/**
 Title of the chart
 */
@property(nonatomic,copy) NSString* title;

/**
 Name of the chart
 */
@property(nonatomic,copy) NSString* name;

/**
 Gets the current scale for text rendering in the chart view.
 */
@property(nonatomic, readonly) CGFloat textScale;

/**
 A Boolean value that indicates whether the chart is in the midst of refreshing its data
 */
@property(nonatomic) BOOL refreshing;

#pragma mark -
#pragma mark Refresh / Redraw

/**
 @brief Refresh chart. 

 Call this method to reload data and refresh all chart specifiedations in an asynchornous thread
 */
- (void)refresh;

/**
 @brief Refresh chart in synchronous mode. 
 
 Call this method to reload data and refresh all chart specifiedations.
 */
- (void)refreshSync;

/**
 @brief Reloads data model of the chart in the main thread
 */
- (void)reloadData;

/**
 @brief Reloads data model of the chart in an asynchronous thread
 */
- (void)reloadDataAsync;

/**
 @brief Redraw chart. 

 Call this method to redraw chart with all chart specifiedations changes (data will not be reloaded).
 */
- (void)redraw:(BOOL)animated;

/**
 @brief Quickly redraw chart. 
 
 Call this method to quickly redraw chart based on the current data and specifiedations.
 */
- (void)quickRedraw:(BOOL)animated;


@end




