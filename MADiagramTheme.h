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
//  MADiagramTheme.h
//  MAKit
//
//  Created by Li Zhao on 9/7/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MADiagramTheme <NSObject>

@required

#pragma mark Icons
/*! Image of alert icon
 */
- (UIImage*)alertIcon;

/*! Image of large node layer0
 */
- (UIImage*)largeNodeLayer0;

/*! Image of large node layer1
 */
- (UIImage*)largeNodeLayer1;

/*! Image of large node layer2
 */
- (UIImage*)largeNodeLayer2;

/*! Image of lable of large node
 */
- (UIImage*)largeNodeLabelImage;

/*! Image of left lable of large node
 */
- (UIImage*)largeNodeLabelLeftImage;

/*! Image of right lable of large node
 */
- (UIImage*)largeNodeLabelRightImage;

/*! Image of large axis
 */
- (UIImage*)largeAxisImage;

/*! Image of large scroller
 */
- (UIImage*)largeScroller;

/*! Image of small node layer0
 */
- (UIImage*)smallNodeLayer0;

/*! Image of small node layer1
 */
- (UIImage*)smallNodeLayer1;

/*! Image of small node layer2
 */
- (UIImage*)smallNodeLayer2;

/*! Image of lable of small node
 */
- (UIImage*)smallNodeLabelImage;

/*! Image of left lable of small node
 */
- (UIImage*)smallNodeLabelLeftImage;

/*! Image of right lable of small node
 */
- (UIImage*)smallNodeLabelRightImage;

/*! Image of small axis
 */
- (UIImage*)smallAxisImage;

/*! Image of mini node layer0
 */
- (UIImage*)miniNodeLayer0;

/*! Image of mini axis
 */
- (UIImage*)miniAxisImage;

#pragma mark -
#pragma mark Fonts/Colors

/*! Color of link
 */
- (UIColor*) linkColor;

/*! Color of background
 */
- (UIColor*) backgroundColor;

/*! Color of lable text
 */
- (UIColor*) labelTextColor;

/*! Font of lable text
 */
- (UIFont*) labelTextFont;

/*! Color of value text
 */
- (UIColor*) valueTextColor;

/*! Font of vlaue text
 */
- (UIFont*) valueTextFont;

/*! Color of filling pie
 */
- (UIColor*) pieFillingColor;

@optional


@end
