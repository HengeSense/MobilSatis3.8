//
//  CSJumpQuestion.h
//  MobilSatis
//
//  Created by Kerem Balaban on 22.08.2013.
//
//

#import <Foundation/Foundation.h>

@interface CSJumpQuestion : NSObject
{
    NSString *surveyNo;
    NSString *questionNumber;
    NSString *answerId;
    NSString *jumpQuestion;
}

@property(nonatomic,retain) NSString *surveyNo;
@property(nonatomic,retain) NSString *questionNumber;
@property(nonatomic,retain) NSString *answerId;
@property(nonatomic,retain) NSString *jumpQuestion;

@end
