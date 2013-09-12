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

/*
 *  MALog.h
 *  MAExpression
 *
 *  Created by Anders Karlsson on 5/20/10.
 *  Copyright 2010 Sybase Inc. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


/*! 
 *	\brief Class for logging
 */
@interface MALog : NSObject 
{
}	

/**
 * use trace when you want log performance data
 *
 * NOTE : you must end the argument list with nil e.g. [MALog trace:@"somestring", nil ]
 */

+(void)performanceTrace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * use trace when you want log things optionally
 *
 * NOTE : you must end the argument list with nil e.g. [MALog trace:@"somestring", nil ]
 */

+(void)trace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * use trace when you want log things if trace level is ==2
 *
 * NOTE : you must end the argument list with nil e.g. [MALog trace:@"somestring", nil ]
 */

+(void)verbose:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * use trace when you want log things mandatory without prefixed error ### label
 *
 * NOTE : you must end the argument list with nil e.g. [MALog trace:@"somestring", nil ]
 */

+(void)forceTrace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * always will be logged messages will be prefixed with ###
 *
 * NOTE : you must end the argument list with nil e.g. [MALog error:@"somestring", nil ]
 */

+(void)error:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * always will be logged messages will be prefixed with ===
 *
 * NOTE : you must end the argument list with nil e.g. [MALog warning:@"somestring", nil ]
 */

+(void)warning:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * this function sets the trace level, currently
 * only 0 and 1 are supported where 1 == trace on.
 */
+(int)setTraceLevel:(int)newTraceLevel;

/**
 * this function gets the trace level.
 */
+(int)getTraceLevel;

@end