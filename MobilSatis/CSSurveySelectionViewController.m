//
//  CSSurveyQuestionsViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 04.07.2013.
//
//

#import "CSSurveySelectionViewController.h"

@interface CSSurveySelectionViewController ()

@end

@implementation CSSurveySelectionViewController
@synthesize tableView,surveyId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithUser:(CSUser *)myUser andNibName:(NSString *)nibName andKunnr:(NSString*)kunnr
{
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    myk = myUser.username;
    customerKunnr = kunnr;
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    
    surveyName = [[NSMutableArray alloc] init];
    surveyQuestions = [[NSMutableArray alloc] init];
    jumpArray = [[NSMutableArray alloc] init];
    questionArray = [[NSMutableArray alloc] init];
    surveyList = [[NSMutableArray alloc] init];
    
    [surveyList removeAllObjects];
    [questionArray removeAllObjects];
    
    [[self navigationItem] setTitle:@"Anket Seçimi"];
    
    [self getSurveyQuestions];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sistemdeki Anket isimlerini alıyoruz......
-(void)getSurveyQuestions{
    [super playAnimationOnView:self.view];
    NSString *tablePartners    = [NSString stringWithFormat:@"ET_SURVEY_LIST"];
    
    NSMutableArray *columnsPartners    = [[NSMutableArray alloc] init];
    [columnsPartners addObject:@"SURVEY_NAME"];
    [columnsPartners addObject:@"SURVEY_ID"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword]
                         andRFCName:@"ZMOB_GET_SURVEY_QUESTIONS"];
    
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:customerKunnr];
    [sapHandler addImportWithKey:@"I_UNAME" andValue:myk];
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:tablePartners andColumns:columnsPartners];
    [sapHandler prepCall];
}

// Anket isimlerine göre soruları ve cevapları alıyoruz....
-(void)getQuestionsAnswersFromSurvey:(NSString*)surveyId{
    [surveyList removeAllObjects];
    [questionArray removeAllObjects];
    
    [super playAnimationOnView:self.view];
    NSString *questionTable    = [NSString stringWithFormat:@"ET_SURVEY"];
    NSString *jumpTable    = [NSString stringWithFormat:@"ET_JUMP_LIST"];
    
    NSMutableArray *questionColumns    = [[NSMutableArray alloc] init];
    [questionColumns addObject:@"TYPE"];
    [questionColumns addObject:@"ANSWER_ID"];
    [questionColumns addObject:@"ID"];
    [questionColumns addObject:@"TEXT"];
    [questionColumns addObject:@"SELECTED"];
    [questionColumns addObject:@"ANSWER_TYPE"];
    
    NSMutableArray *jumpColumns = [[NSMutableArray alloc] init];
    [jumpColumns addObject:@"SURVEY_ID"];
    [jumpColumns addObject:@"QUESTION_NO"];
    [jumpColumns addObject:@"ANSWER"];
    [jumpColumns addObject:@"JUMP_QUESTION_NO"];
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword]
                         andRFCName:@"ZMOB_GET_SURVEY_QUESTIONS"];
    
    [sapHandler addImportWithKey:@"I_SURVEY_NAME" andValue:surveyId];
    
    [sapHandler setDelegate:self];
    [sapHandler addTableWithName:questionTable andColumns:questionColumns];
    [sapHandler addTableWithName:jumpTable andColumns:jumpColumns];
    [sapHandler prepCall];
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
//    NSRange range = [myResponse rangeOfString:@"item"];
//    if (range.length > 0)
//    {
        NSMutableArray *responses1 = [ABHXMLHelper getValuesWithTag:@"ZMOB_T_SURVEY" fromEnvelope:myResponse];
        NSMutableArray *responses2 = [ABHXMLHelper getValuesWithTag:@"ZMOB_S_SURVEY_QUESTIONS" fromEnvelope:myResponse];
        NSMutableArray *responses3 = [ABHXMLHelper getValuesWithTag:@"ZMOB_T_SVY_ATLA" fromEnvelope:myResponse];
        
        if ([responses1 count] > 0 ) {
            
            NSString *error = [[ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse] objectAtIndex:0];
            NSString *message = [[ABHXMLHelper getValuesWithTag:@"E_MESSAGE" fromEnvelope:myResponse] objectAtIndex:0];
            
            NSMutableArray *survey = [[NSMutableArray alloc] init];
            NSMutableArray *survId = [[NSMutableArray alloc] init];
            
            if ([error isEqualToString:@"F"])
            {
                [super stopAnimationOnView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:message delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
                
                [alert show];
                return;
                
            }
            else
            {
                survey = [ABHXMLHelper getValuesWithTag:@"SURVEY_NAME" fromEnvelope:[responses1 objectAtIndex:0]];
                survId = [ABHXMLHelper getValuesWithTag:@"SURVEY_ID" fromEnvelope:[responses1 objectAtIndex:0]];
                
                if ([survey count] > 0) {
                    for (int i = 0; i < [survey count]; i++) {
                        NSString *surName = [survey objectAtIndex:i];
                        NSString *surId = [survId objectAtIndex:i];
                        NSArray *surveyArr = [NSArray arrayWithObjects:surName,surId,nil];
                        
                        [surveyName addObject:surveyArr];
                    }
                    [tableView reloadData];
                    [super stopAnimationOnView];
                }
                else
                {
                    [super stopAnimationOnView];
                }
            }
        }
        if ([responses2 count] > 0)
        {
            NSMutableArray *typeArr = [[NSMutableArray alloc] init];
            NSMutableArray *answer_id = [[NSMutableArray alloc] init];
            NSMutableArray *question_id = [[NSMutableArray alloc] init];
            NSMutableArray *text = [[NSMutableArray alloc] init];
            NSMutableArray *selected = [[NSMutableArray alloc] init];
            NSMutableArray *answer_type = [[NSMutableArray alloc] init];
            
            typeArr = [ABHXMLHelper getValuesWithTag:@"TYPE" fromEnvelope:[responses2 objectAtIndex:0]];
            answer_id = [ABHXMLHelper getValuesWithTag:@"ANSWER_ID" fromEnvelope:[responses2 objectAtIndex:0]];
            question_id = [ABHXMLHelper getValuesWithTag:@"ID" fromEnvelope:[responses2 objectAtIndex:0]];
            text = [ABHXMLHelper getValuesWithTag:@"TEXT" fromEnvelope:[responses2 objectAtIndex:0]];
            selected = [ABHXMLHelper getValuesWithTag:@"SELECTED" fromEnvelope:[responses2 objectAtIndex:0]];
            answer_type = [ABHXMLHelper getValuesWithTag:@"ANSWER_TYPE" fromEnvelope:[responses2 objectAtIndex:0]];
            
            NSString *questionNo;
            
            if ([typeArr count] > 0) {
                for (int i = 0; i < [typeArr count]; i++) {
                    
                    if ([[typeArr objectAtIndex:i] isEqualToString:@"Question"]) {
                        NSString *type = [typeArr objectAtIndex:i];
                        NSString *answer = [answer_id objectAtIndex:i];
                        NSString *question = [question_id objectAtIndex:i];
                        NSString *texts = [text objectAtIndex:i];
                        NSString *answerType = [answer_type objectAtIndex:i];
                        
                        CSSurveyObject *obj = [[CSSurveyObject alloc] init];
                        
                        obj.types = type;
                        obj.answerId = answer;
                        obj.questionId = question;
                        obj.texts = texts;
                        obj.answerTypes = answerType;
                        
                        NSArray *arr = [texts componentsSeparatedByString:@"-"];
                        questionNo = [arr objectAtIndex:0];
                        obj.questionNo = questionNo;
                        
                        [questionArray addObject:obj];
                        
                    }
                    
                    if ([[typeArr objectAtIndex:i] isEqualToString:@"Answer"]) {
                        NSString *type = [typeArr objectAtIndex:i];
                        NSString *answer = [answer_id objectAtIndex:i];
                        NSString *question = [question_id objectAtIndex:i];
                        NSString *texts = [text objectAtIndex:i];
                        NSString *answerType = [answer_type objectAtIndex:i];
                        
                        CSSurveyObject *obj = [[CSSurveyObject alloc] init];
                        obj.types = type;
                        obj.answerId = answer;
                        obj.questionId = question;
                        obj.texts = texts;
                        obj.answerTypes = answerType;
                        obj.questionNo = questionNo;
                        
                        [questionArray addObject:obj];
                        
                    }
                    
                }
                
                CSSurveyQuestion *surveyQuestion;
                for (int i = 0; i < [questionArray count]; i++) {
                    
                    if ([[[questionArray objectAtIndex:i] types] isEqualToString:@"Question"]) {
                        
                        if ([[surveyQuestion answers] count] > 0) {
                            [surveyList addObject:surveyQuestion];
                        }
                        
                        surveyQuestion = [[CSSurveyQuestion alloc] initWithArray];
                        surveyQuestion.questionNo = [[questionArray objectAtIndex:i] questionNo];
                        surveyQuestion.question = (CSSurveyObject *)[questionArray objectAtIndex:i];
                    }
                    
                    if ([[[questionArray objectAtIndex:i] types] isEqualToString:@"Answer"]) {
                        [surveyQuestion.answers addObject:[questionArray objectAtIndex:i]];
                    }
                }
                if ([[surveyQuestion answers] count] > 0) {
                    [surveyList addObject:surveyQuestion];
                }
            }
        }
        if ([responses3 count] > 0) {
            NSMutableArray *survey_Id = [[NSMutableArray alloc] init];
            NSMutableArray *question_Id = [[NSMutableArray alloc] init];
            NSMutableArray *answer_Id = [[NSMutableArray alloc] init];
            NSMutableArray *jump_Id = [[NSMutableArray alloc] init];
            
            survey_Id = [ABHXMLHelper getValuesWithTag:@"SURVEY_ID" fromEnvelope:[responses3 objectAtIndex:0]];
            question_Id = [ABHXMLHelper getValuesWithTag:@"QUESTION_NO" fromEnvelope:[responses3 objectAtIndex:0]];
            answer_Id = [ABHXMLHelper getValuesWithTag:@"ANSWER" fromEnvelope:[responses3 objectAtIndex:0]];
            jump_Id = [ABHXMLHelper getValuesWithTag:@"JUMP_QUESTION_NO" fromEnvelope:[responses3 objectAtIndex:0]];
            
            
            for (int j = 0; j < [survey_Id count]; j++)
            {
                NSString *surveyNo = [survey_Id objectAtIndex:j];
                NSString *questionNo = [question_Id objectAtIndex:j];
                NSString *answerNo = [answer_Id objectAtIndex:j];
                NSString *jumpNo   = [jump_Id objectAtIndex:j];
                
                CSJumpQuestion *jumpObject = [[CSJumpQuestion alloc] init];
                jumpObject.surveyNo = surveyNo;
                jumpObject.questionNumber = questionNo;
                jumpObject.answerId = answerNo;
                jumpObject.jumpQuestion = jumpNo;
                
                [jumpArray addObject:jumpObject];
            }
            [super stopAnimationOnView];
            NSString *nibName;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nibName = @"CSSurveyQuestionsViewController_Ipad";
            }else
            {
                nibName = @"CSSurveyQuestionsViewController";
            }
            CSSurveyQuestionsViewController *surveyQuestion = [[CSSurveyQuestionsViewController alloc] initWithArray:surveyList andJumpArray:jumpArray andNibName:nibName andSurveyId:surveyId andUser:myk andKunnr:customerKunnr];
            
            [[self navigationController] pushViewController:surveyQuestion animated:YES];
        }
//    }
//    else
//    {
//        [super stopAnimationOnView];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Açık anketiniz bulunmamaktadır" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        return;
//        
//    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [surveyName count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [[cell textLabel]setText:[[surveyName objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    surveyId = [[surveyName objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [surveyQuestions removeAllObjects];
    [self getQuestionsAnswersFromSurvey:surveyId];
    
    
    //        NSString *nibName;
    //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    //            nibName = @"CSSurveyQuestionsViewController_Ipad";
    //        }else{
    //            nibName = @"CSSurveyQuestionsViewController";
    //        }
    //
    //        CSSurveyQuestionsViewController *surveyQuestion = [[CSSurveyQuestionsViewController alloc] initWithArray:surveyQuestions andNibName:nibName];
    //
    //        [[self navigationController] pushViewController:surveyQuestion animated:YES];
    
}

@end
