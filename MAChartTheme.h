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
//  MAChartTheme.h
//  MAKit
//
//  Created by Zhang Jie on 10/23/10.
//  Copyright 2010 Sybase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAChartSpec;
@protocol MAChartBasePainter;
@protocol MAChartSeriesPainter;

/** 
 @ingroup Chart
 @brief Protocol of chart theme
 */
@protocol MAChartTheme <NSObject>
		
@required

/**
 @brief To get the chart base painter based on a chart type for the current chart theme
 @param chartType chart type
 @returns The base painter for that chart type
 */
- (id<MAChartBasePainter>)getChartBasePainterByChartType:(NSUInteger)chartType;

/**
 @brief To get the chart series painter based on a chart type for the current chart theme
 @param chartType chart type
 @returns The series painter for that chart type
 */
- (id<MAChartSeriesPainter>)getChartSeriesPainterByChartType:(NSUInteger)chartType;

/**
 @returns The font for title
 */
- (UIFont*)getChartTitleFont;

/**
 @returns The font for legend
 */
- (UIFont*)getChartLegendFont;

/**
 @returns The font for category labels
 */
- (UIFont*)getCategoryLabelFont;

/**
 @returns The font for value labels
 */
- (UIFont*)getValueLabelFont;

#pragma mark -
#pragma mark Colors

/**
 @brief To get the background color of chart.
 */
- (UIColor*)chartBackgroundColor;

/**
 @brief To get the border color of chart.
 */
- (UIColor*)chartBorderColor;

/**
 @brief To get the color of chart title text.
 */
- (UIColor*)chartTitleTextColor;

/**
 @brief To get the background color of chart legend.
 */
- (UIColor*)chartLegendBackgroundColor;

/**
 @brief To get the border color of chart legend.
 */
- (UIColor*)chartLegendBorderColor;

/**
 @brief To get the color of chart legend text.
 */
- (UIColor*)chartLegendTextColor;

/**
 @brief To get the color of value axis of a cartesian chart.
 */
- (UIColor*)cartesianChartValueAxisColor;

/**
 @brief To get the  color of value axis marker text of a cartesian chart.
 */
- (UIColor*)cartesianChartValueAxisMarkerTextColor;

/**
 @brief To get the  color of value axis label text of a cartesian chart.
 */
- (UIColor*)cartesianChartValueLabelTextColor;

/**
 @brief To get the color of category axis of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryAxisColor;

/**
 @brief To get the color of category axis marker text of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryAxisMarkerTextColor;

/**
 @brief To get the color of category axis label text of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryLabelTextColor;

/**
 To get the color of guidelines of a cartesian chart.
 */
- (UIColor*)cartesianChartGuidelineColor;

/**
 @brief To get the background color of category with even index value.
 Return different color from the cartesianChartOddCategoryBackgroundColor to achieve alternate background colors
 */
- (UIColor*)cartesianChartEvenCategoryBackgroundColor;

/**
 @brief To get the background color of category with odd index value.
 Return different color from the cartesianChartEvenCategoryBackgroundColor to achieve alternate background colors
 */
- (UIColor*)cartesianChartOddCategoryBackgroundColor;

/**
 To get the color of highlighted area of a chart.
 */
- (UIColor*)chartHighlightColor;

/**
 @brief To get the color of Dynamic Analytics variable description label.
 */
- (UIColor*)dynamicAnalyticsVariableDescriptionColor;

/**
 @brief To get the color of Dynamic Analytics variable value label.
 */
- (UIColor*)dynamicAnalyticsVariableValueColor;

/**
 @brief To get the background color of a chart detail view.
 */
- (UIColor*)chartDetailBackgroundColor;

/**
 To get the content color of a chart series with index.
 @param seriesIndex The index of series.
 @returns content color of the specified series.
 */
- (UIColor*)getChartSeriesContentColorForIndex:(NSUInteger)seriesIndex;

/**
 To get the border color of a chart series with index.
 @param seriesIndex The index of series.
 @returns border color of the specified series.
 */
- (UIColor*)getChartSeriesBorderColorForIndex:(NSUInteger)seriesIndex;

@optional

/**
 @brief To get the color of datagrid lines.
 */
- (UIColor*)dataGridLinesColor;

/**
 @brief To get the color of datagrid categeory  Text color.
 */
- (UIColor*)dataGridCatgeoryTextColor;

/**
 @brief To get the color of data grid header background color.
 */
- (UIColor*)dataGridHeaderBackgroundColor;

/**
 @brief To get the color of data grid background color.
 */
- (UIColor*)dataGridBackgroundColor;

/**
 @brief To get the font of datagrid.
 */
-(UIFont*)dataGridFont;

/**
 @brief To get the datagrid horizontal line1 color.
 */
 
- (UIColor*)dataGridHorizontalLine1Color;

/**
  @brief To get the datagrid horizontal line1 color.
 */
- (UIColor*)dataGridHorizontalLine2Color;

@end
