//
//  CSSurveyQuestionsViewController.h
//  MobilSatis
//
//  Created by Kerem Balaban on 04.07.2013.
//
//

#import "CSBaseViewController.h"
#import "CSSurveyQuestionsViewController.h"
#import "CSUser.h"
#import "CSSurveyQuestion.h"
#import "CSJumpQuestion.h"

@interface CSSurveySelectionViewController: CSBaseViewController <UITableViewDataSource,UITableViewDelegate,ABHSAPHandlerDelegate>
{
    NSMutableArray *surveyName;
    NSString *surveyId;
    NSMutableArray *surveyQuestions;
    NSMutableArray *jumpArray;
    NSString *myk;
    NSString *customerKunnr;
    NSMutableArray *questionArray;
    NSMutableArray *surveyList;
}


@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString *surveyId;

- (id) initWithUser:(CSUser *)myUser andNibName:(NSString *)nibName andKunnr:(NSString*)kunnr;
@end
