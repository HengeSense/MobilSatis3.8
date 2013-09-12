//
//  CSSurveyObject.h
//  MobilSatis
//
//  Created by Kerem Balaban on 21.08.2013.
//
//

#import <Foundation/Foundation.h>

@interface CSSurveyObject : NSObject
{
    NSString *texts;
    NSString *questionNo;
    NSString *questionId;
    NSString *answerId;
    NSString *types;
    NSString *answerTypes;
}

@property (nonatomic,retain) NSString *texts;
@property (nonatomic,retain) NSString *questionNo;
@property (nonatomic,retain) NSString *questionId;
@property (nonatomic,retain) NSString *answerId;
@property (nonatomic,retain) NSString *types;
@property (nonatomic,retain) NSString *answerTypes;

@end
