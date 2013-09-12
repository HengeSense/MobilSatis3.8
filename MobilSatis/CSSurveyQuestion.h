//
//  CSSurveyQuestion.h
//  MobilSatis
//
//  Created by Kerem Balaban on 21.08.2013.
//
//

#import <Foundation/Foundation.h>
#import "CSSurveyObject.h"

@interface CSSurveyQuestion : NSObject
{
    NSString *questionNo;
    CSSurveyObject *question;
    NSMutableArray *answers;
}
@property (nonatomic,retain) NSString *questionNo;
@property (nonatomic,retain) CSSurveyObject *question;
@property (nonatomic,retain) NSMutableArray *answers;

- (id)initWithArray;

@end
