//
//  CSSurveyCreate.h
//  MobilSatis
//
//  Created by Kerem Balaban on 23.08.2013.
//
//

#import <Foundation/Foundation.h>

@interface CSSurveyCreate : NSObject
{
    NSString *idx;
    NSString *questionId;
    NSString *answerId;
    NSString *answerValue;
}

@property (nonatomic,retain) NSString *idx;
@property (nonatomic,retain) NSString *questionId;
@property (nonatomic,retain) NSString *answerId;
@property (nonatomic,retain) NSString *answerValue;
@end
