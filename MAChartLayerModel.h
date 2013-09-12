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
//  MAChartLayerModel.h
//  MAKit
//
//  Created by Zhang Jie on 4/17/11.
//  Copyright 2011 Sybase Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAChartRenderType.h"

/**
 * chart layer protocol
 */
@protocol MAChartLayerModel <NSObject>

@required

/** 
 @brief Gets the number of layers
 @returns The layer count
 */
- (NSUInteger)chartLayerCount;

/**
 @brief Gets the chart type for a chart layer at a specified index
 @param layerIndex An index corresponding to a chart layer
 @returns The chart type for the layer
 */
- (NSUInteger)chartTypeForChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the chart render type for a chart layer at a specified index
 @param layerIndex An index corresponding to a chart layer
 @returns The chart render type for the layer
 */
- (MAChartRenderType)chartRenderTypeForChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the number of series at a specified layer
 @param layerIndex An index corresponding to a chart layer
 @returns The series count in the layer
 */
- (NSUInteger)seriesCountForChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the series at a specified index within a specified chart layer
 @param seriesIndex An index corresponding to a series.  The index is based on the chart layer the series belongs to.
 @param layerIndex An index corresponding to a chart layer.
 @returns The series object
 */
- (id)seriesAtIndex:(NSUInteger)seriesIndex forChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the value of a specified category-series pair.  The series is located in the chart layer it belongs to.
 @param categoryIndex An index corresponding to a category in category level 0.
 @param layerSeriesIndex An index corresponding to a series in the chart layer it belongs to.
 @param layerIndex An index corresponding to a chart layer.
 @returns The value object
 */
- (id)valueOfCategory:(NSUInteger)categoryIndex andLayerSeries:(NSUInteger)layerSeriesIndex forChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the value at a specified dimension of a specified category-series pair.  The series is located in the chart layer it belongs to.
 @param valueDimensionIndex An index corresponding to a value dimension.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @param layerSeriesIndex An index corresponding to a series in the chart layer it belongs to.
 @param layerIndex An index corresponding to a chart layer.
 @returns The value object
 */
- (id)valueAtDimension:(NSUInteger)valueDimensionIndex ofCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andLayerSeries:(NSUInteger)layerSeriesIndex forChartLayer:(NSUInteger)layerIndex;

/**
 @brief Converts an index corresponding to a series in a specified layer to a global series index based on all chart layers.
 @param layerSeriesIndex An index corresponding to a series in the chart layer it belongs to.
 @param layerIndex An index corresponding to a chart layer.
 @returns globalSeriesIndex An index corresponding to a a series based on all chart layers
 */
- (NSUInteger)convertToGlobalSeriesIndexFromLayerSeriesIndex:(NSUInteger)layerSeriesIndex forChartLayer:(NSUInteger)layerIndex;

/**
 @brief Gets the formatted string of the value at a specified dimension of a specified category-series pair.  The series is located in the chart layer it belongs to.
 @param valueDimensionIndex An index corresponding to a value dimension.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @param layerSeriesIndex An index corresponding to a series in the chart layer it belongs to.
 @param layerIndex An index corresponding to a chart layer.
 @returns The formatted string of the value
 */
- (NSString*)formattedStringFromValueAtDimension:(NSUInteger)valueDimensionIndex ofCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andLayerSeries:(NSUInteger)layerSeriesIndex forChartLayer:(NSUInteger)layerIndex;

@end
