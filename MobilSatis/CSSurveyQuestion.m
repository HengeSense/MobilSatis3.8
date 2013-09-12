//
//  CSSurveyQuestion.m
//  MobilSatis
//
//  Created by Kerem Balaban on 21.08.2013.
//
//

#import "CSSurveyQuestion.h"

@implementation CSSurveyQuestion
@synthesize questionNo,answers,question;

- (id)initWithArray {
    self = [super init];
    self.answers = [[NSMutableArray alloc] init];
    
    return self;
}
@end
