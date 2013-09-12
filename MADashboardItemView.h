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
//  MADashboardItemView.h
//
//  Created by Zhang Jie on 9/28/09.
//  Copyright 2009 Sybase Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MADashboardTheme.h"
#import "MADashboardView.h"


@interface MADashboardItemView : UIView 
{
}

/**
 The index path locating the dashboard item in the dashboard
 */
@property (nonatomic, retain) NSIndexPath *indexPath;

/**
 The dashboard of which the dashboard item should be displayed within
 */
@property (nonatomic, assign) MADashboardView* dashboard;

/**
 The object acting as the theme of the dashboard
 */
@property (nonatomic, retain) id<MADashboardTheme> theme; 

/**
 The select button
 */
@property (nonatomic, retain) UIButton *selectButton;

/**
 The title label
 */
@property (nonatomic, retain) UILabel *titleLabel;

/**
 The content view
 */
@property (nonatomic, retain) UIView *contentView;

/**
 A Boolean value indicating the selection state
 */
@property(nonatomic, getter=isSelected) BOOL selected;

/**
 @brief Selects the dashboard item
 
 @param animated If YES, animates the transition; otherwise, does not.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
