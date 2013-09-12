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
//  MAChartDataModel.h
//  MAKit
//
//  Created by Zhang Jie on 4/16/11.
//  Copyright 2011 Sybase Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAChartDataModel <NSObject>

@required

#pragma mark - Data Access

#pragma mark Category

/**
 @brief Gets the number of category levels
 @returns The category level count
 */
- (NSUInteger)categoryLevelCount;

/**
 @brief Gets the number of categories for category level 0
 @returns The category count
 */
- (NSUInteger)categoryCount;

/**
 @brief Gets the number of categories for a specified category level 
 @returns the category count
 */
- (NSUInteger)categoryCountInLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the category at a specified index in category level 0
 @param categoryIndex An index corresponding to a category
 @returns The category object
 */
- (id)categoryAtIndex:(NSUInteger)categoryIndex;

/**
 @brief Gets the category at a specified index in a specified category level
 @param categoryIndex An index corresponding to a category
 @param categoryLevelIndex An index corresponding to a category level
 @returns The category object
 */
- (id)categoryAtIndex:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the category of the specified data item
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers
 @returns The category object
 */
- (id)categoryOfDataItem:(NSUInteger)dataItemIndex andSeries:(NSUInteger)globalSeriesIndex;

/**	
 @brief Gets the category index of the specified data item
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers
 @returns The category index
 */
- (NSUInteger)categoryIndexOfDataItem:(NSUInteger)dataItemIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the title of category for category level 0, which could be used for axis labelling & table headers
 @returns The label.
 */
- (NSString*)categoryTitle;

/**
 @brief Gets the title of category for a specified category level, which could be used for axis labelling & table headers
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)categoryTitleForCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the formatter object for categories.
 @returns The formatter object
 */
@property(nonatomic,readonly) NSFormatter* categoryFormatter;

/**
 @brief Queries whether category can be interpreted as a value dimension.
 
 This is the case whereby there are multiple data items corresponding to each category/series pair.
 */
- (BOOL)isCategoryInterpretedAsValue;

/**
 @brief Gets the index of the first sub-category of a specified category in a specified category level
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of the first sub-category in the sub-category's own level.
 */
- (NSUInteger)indexOfFirstSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the index of the last sub-category of a specified category in a specified category level
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of the last sub-category in the sub-category's own level.
 */
- (NSUInteger)indexOfLastSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the index of the first sub-category in category level 0 of a specified category in a specified category level
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of the first sub-category in category level 0.
 */
- (NSUInteger)indexOfFirstLevelZeroSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the index of the last sub-category in category level 0 of a specified category in a specified category level
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of the last sub-category in category level 0.
 */
- (NSUInteger)indexOfLastLevelZeroSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

#pragma mark Series

/**
 @brief Gets the total number of series for all layers
 @returns The series count
 */
- (NSUInteger)seriesCount;

/**
 @brief Gets the number of data items at a specified series
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers
 @returns The data item count in the series
 */
- (NSUInteger)dataItemCountForSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the series at a specified index within all chart layers
 @param globalSeriesIndex An index corresponding to a series.  The index is based on all chart layers.
 @returns The series object
 */
- (id)seriesAtIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the title of series for category level 0, which could be used for axis labelling & table headers
 @returns The label.
 */
- (NSString*)seriesTitle;

/**
 @brief Gets the title of series for a specified category level, which could be used for axis labelling & table headers
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)seriesTitleForCategoryLevel:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the formatter object for series.
 @returns The formatter object
 */
- (NSFormatter*)seriesFormatter;

#pragma mark Value

/**
 @brief Gets the number of dimensions of the values in the chart view
 @returns The number of value dimensions
 */
- (NSUInteger)numberOfValueDimensions;

/**
 @brief Gets the value of a specified category-series pair
 @param categoryIndex An index corresponding to a category in category level 0.
 @param globalSeriesIndex An index corresponding to a series.  The index is based on all chart layers.
 @returns The value object
 */
- (id)valueOfCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the value at a specified dimension of a specified category-series pair
 @param valueDimensionIndex An index corresponding to a value dimension.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @param globalSeriesIndex An index corresponding to a series.  The index is based on all chart layers.
 @returns The value object
 */
- (id)valueAtDimension:(NSUInteger)valueDimensionIndex ofCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the value of the specified data item
 @param valueDimensionIndex An index corresponding to the value dimension.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers
 @returns The value object
 */
- (id)valueAtDimension:(NSUInteger)valueDimensionIndex ofDataItem:(NSUInteger)dataItemIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the formatted string of the value at a specified dimension of a specified category-series pair
 @param valueDimensionIndex An index corresponding to a value dimension.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @param globalSeriesIndex An index corresponding to a series.  The index is based on all chart layers.
 @returns The formatted string of the value
 */
- (NSString*)formattedStringFromValueAtDimension:(NSUInteger)valueDimensionIndex ofCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 Gets the formatter object for values at a specified dimension.
 @param valueDimensionIndex An index corresponding to a value dimension.
 @returns The formatter object
 */
- (NSFormatter*)formatterForValueAtDimension:(NSUInteger)valueDimensionIndex;

/**
 @brief Gets the title of value at the specified dimension, which could be used for axis labelling & table headers.
 @param valueDimensionIndex An index corresponding to the value dimension.
 @returns The label.
 */
- (NSString*)valueTitleAtDimension:(NSUInteger)valueDimensionIndex;

/**
 Gets the title of value at the specified dimension and category level index, which could be used for axis labelling & table headers.
 @param valueDimensionIndex An index corresponding to the value dimension.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)valueTitleAtDimension:(NSUInteger)valueDimensionIndex inCategoryLevelIndex:(NSUInteger)categoryLevelIndex;

/**
 @brief Gets the maximum value
 @param layerIndex An index corresponding to a chart layer
 @param valueDimensionIndex An index corresponding to the value dimension.
 @returns The numeric value.
 */
- (float)maxValueOfLayer:(NSUInteger)layerIndex andValueDimension:(NSUInteger)valueDimensionIndex;    

/**
 @brief Gets the minimum value
 @param layerIndex An index corresponding to a chart layer
 @param valueDimensionIndex An index corresponding to the value dimension.
 @returns The numeric value.
 */
- (float)minValueOfLayer:(NSUInteger)layerIndex andValueDimension:(NSUInteger)valueDimensionIndex;

/**
 @brief Gets the maximum sum of all the values corresponding to the same category
 @param layerIndex An index corresponding to a chart layer
 @param valueDimensionIndex An index corresponding to the value dimension.
 @returns The numeric value.
 */
- (float)maxSumValueOfLayer:(NSUInteger)layerIndex andValueDimension:(NSUInteger)valueDimensionIndex;  

/**
 Gets the minimum sum of all the values corresponding to the same category
 @param layerIndex An index corresponding to a chart layer
 @param valueDimensionIndex An index corresponding to the value dimension.
 @returns The numeric value.
 */
- (float)minSumValueOfLayer:(NSUInteger)layerIndex andValueDimension:(NSUInteger)valueDimensionIndex;

#pragma mark -
#pragma mark Selection States

/**
 @brief Adds the specified category to the selection pool.
 @param categoryIndex An index corresponding to a category in category level 0.
 */
- (void)selectCategoryAtIndex:(NSUInteger)categoryIndex;

/**
 @brief Removes the specified category from the selection pool.
 @param categoryIndex An index corresponding to a category in category level 0.
 */
- (void)deselectCategoryAtIndex:(NSUInteger)categoryIndex;

/**
 Adds the specified series to the selection pool.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)selectSeriesAtIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Removes the specified series from the selection pool.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)deselectSeriesAtIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Adds the specified data item to the selection pool.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)selectDataItemAtIndex:(NSUInteger)dataItemIndex ofGlobalSeriesIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Removes the specified data item from the selection pool.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)deselectDataItemAtIndex:(NSUInteger)dataItemIndex ofGlobalSeriesIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Queries whether a specified category is selected.
 @param categoryIndex An index corresponding to a category in category level 0.
 @returns A Boolean value indicating if the category is selected.
 */
- (BOOL)isCategorySelectedAtIndex:(NSUInteger)categoryIndex;

/**
 @brief Queries whether a specified series is selected.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns A Boolean value indicating if the series is selected.
 */
- (BOOL)isSeriesSelectedAtGlobalIndexForAllChartLayers:(NSUInteger)globalSeriesIndex;

/**
 @brief Queries whether the data is selected.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns A Boolean value indicating if the data item is selected.
 */
- (BOOL)isDataItemSelectedAtIndex:(NSUInteger)dataItemIndex ofGlobalSeriesIndex:(NSUInteger)globalSeriesIndex;

/**	
 @brief Queries whether the data is in focus.
 
 The data item is focused if it is selected. If there is no selection, all data points are in focus.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @see isDataItemSelectedAtIndex
 @returns A Boolean value indicating if the data item is in focus.
 */
- (BOOL)isDataItemInFocusAtIndex:(NSUInteger)dataItemIndex ofGlobalSeriesIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the number of categories in selection.
 @returns The number of categories in selection.
 */
- (NSUInteger)numberOfSelectedCategories;

/**
 @brief Gets the number of series in selection.
 @returns The number of series in selection.
 */
- (NSUInteger)numberOfSelectedSeries;

/**
 @brief Clears all the selections on categories.
 */
- (void)clearAllCategorySelections;

/**
 @brief Clears all the selections on series.
 */
- (void)clearAllSeriesSelections;

/**
 @brief Clears all the selection of the chart.
 */
- (void)clearAllSelections;

/**	
 @brief Queries whether the data is in focus.
 
 The data item is focused if it is selected. If there is no selection, all data points are in focus.
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns A Boolean value indicating if the data is in focus.
 @see isCategorySelectedAtIndex and isSeriesSelectedAtIndex.
 */
- (BOOL)isInFocusAtCategoryIndex:(NSUInteger)categoryIndex ofGlobalSeriesIndex:(NSUInteger)globalSeriesIndex;

/**
 @brief Gets the index of the highlight category.
 @returns the index of the category.
 */
- (NSUInteger)highlightCategoryIndex;

/** 
 @brief Gets the index of the first selected series.
 @returns the index of the series.
 */
-(NSInteger)indexOfFirstSelectedSeries;

/**
 @brief Sets the index of the highlighted category.
 @param categoryIndex the index of the category.
 */
- (void)setHighlightCategoryIndex:(NSUInteger)categoryIndex;

#pragma mark - Managing Colors

/**
 @brief Get the content color for a series.
 
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns The color object.
 */
- (UIColor *)contentColorForSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Get the border color for a series.
 
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns The color object.
 */
- (UIColor *)borderColorForSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Set the content color for a series.
 
 @param color The color object.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)setContentColor:(UIColor*)color forSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Set the border color for a series.
 
 @param color The color object.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)setBorderColor:(UIColor*)color forSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Get the content color for a category-series combination.
 
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns The color object.
 */
- (UIColor *)contentColorForCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Get the border color for a category-series combination.
 
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 @returns The color object.
 */
- (UIColor *)borderColorForCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Set the content color for a category-series combination.
 
 @param color The color object.
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)setContentColor:(UIColor*)color forCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Set the border color for a category-series combination.
 
 @param color The color object.
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a a series based on all chart layers.
 */
- (void)setBorderColor:(UIColor*)color forCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex;

/**
 @brief Reset all content and border colors back to default values.
 */
- (void)resetAllColors;

@end
