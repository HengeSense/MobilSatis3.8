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
//  MAChartViewDelegate.h
//  MAKit
//
//  Created by Zhang Jie on 2/8/11.
//  Copyright 2011 Sybase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAChartView;

/** 
 @ingroup Chart
 @brief Protocol of chart view delegate

 This protocol defines methods and properties that needs to be implemented by a chart view delegate. 
 */
@protocol MAChartViewDelegate <NSObject>

@optional

/**
 @brief Tells the delegate that data in the chart view is about to be refreshed.
 
 @param chartView An object representing the chart view requesting this information.
 @returns Return YES if you want the data refreshed; NO if don't.
 */
- (BOOL)willRefreshDataInChartView:(MAChartView *)chartView;

/**
 @brief Tells the delegate that data in the chart view has been refreshed.
 
 @param chartView An object representing the chart view requesting this information.
 */
- (void)didRefreshDataInChartView:(MAChartView *)chartView;

#pragma mark - Managing Range Selection

/**
 @brief Tells the receiver when the horizontal range has been updated.
 
 @param chartView An object representing the chart view requesting this information.
 @param lowerBound lower bound of the range (0 ~ 1)
 @param upperBound upper bound of the range (0 ~ 1)
 */
- (void)chartView:(MAChartView *)chartView didUpdateHorizontalRangeWithLowerBound:(float)lowerBound andUpperBound:(float)upperBound;

/**
 @brief Tells the receiver when the vertical range has been updated.
 
 @param chartView An object representing the chart view requesting this information.
 @param lowerBound lower bound of the range (0 ~ 1)
 @param upperBound upper bound of the range (0 ~ 1)
 */
- (void)chartView:(MAChartView *)chartView didUpdateVerticalRangeWithLowerBound:(float)lowerBound andUpperBound:(float)upperBound;

#pragma mark - Managing Selections

/**
 @brief Tells the delegate that a specified category is about to be selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @returns Return YES if you want the category selected; NO if don't.
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified category is now selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 */
- (void)chartView:(MAChartView *)chartView didSelectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that a specified category is about to be deselected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @returns Return YES if you want the category deselected; NO if don't.
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified category is now deselected.

 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDeselectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that a specified series is about to be selected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 @returns Return YES if you want the series selected; NO if don't.
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified series is now selected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didSelectSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that a specified series is about to be deselected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 @returns Return YES if you want the series deselected; NO if don't.
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified series is now deselected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDeselectSeries:(NSUInteger)seriesIndex;

/**
 @brief Queries whether to select data item.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to select. NO otherwise
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**	
 @brief Informs the receiver that the data item is selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to select. NO otherwise
 */
- (void)chartView:(MAChartView *)chartView didSelectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**	
 @brief Queries whether to deselect data item.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to deselect. NO otherwise
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**	
 @brief Informs the receiver that the data item is deselected.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to deselect. NO otherwise
 */
- (void)chartView:(MAChartView *)chartView didDeselectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that treemap Level is changed.
 
 @param chartView An object representing the chart view requesting this information.
 */
- (void)categoryLevelChanged:(MAChartView *)chartView;

#pragma mark - Managing Touch Events

/**
 @brief Tells the delegate that the specified category has been double tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDoubleTapOnCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified series has been double tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDoubleTapOnSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified category has been double tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDoubleTapOnCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)seriesIndex;

@end
