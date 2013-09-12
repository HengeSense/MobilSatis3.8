//
//  CSSurveyQuestionsViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 08.07.2013.
//
//

#import "CSBaseViewController.h"
#import "CSSurveyQuestion.h"
#import "CSJumpQuestion.h"
#import "CSSurveyCreate.h"
#import "CSPrevQuestion.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface CSSurveyQuestionsViewController: CSBaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,ABHSAPHandlerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIScrollView *scrollView;
    
    NSMutableArray *surveyQuestions;
    NSMutableArray *jumpQuestions;
    NSMutableArray *selectedIndex;
    NSMutableArray *answerTexts;
    NSMutableArray *surveyCreate;
    NSMutableArray *prevQuestionList;
    
    UITextField *textField;
    UITextField *activeField;
    
    CSSurveyQuestion *prevQuestion;
    
    NSString *surveyId;
    NSString *answerId;
    NSString *questionId;
    NSString *value;
    NSString *longText;
    NSString *myk;
    NSString *customerNo;
}
@property (nonatomic,retain) UITextField *textField;
-(id)initWithArray:(NSMutableArray *)array andJumpArray:(NSMutableArray *)jumpArr andNibName:(NSString *)nibName andSurveyId:(NSString *)surveyName andUser:(NSString *)myUser andKunnr:(NSString*)kunnr;

@end
