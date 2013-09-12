//
//  CSSurveyQuestionsViewController.m
//  MobilSatis
//
//  Created by Kerem Balaban on 08.07.2013.
//
//

#import "CSSurveyQuestionsViewController.h"

@interface CSSurveyQuestionsViewController ()

@end

@implementation CSSurveyQuestionsViewController
@synthesize textField;

int counter = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithArray:(NSMutableArray *)array andJumpArray:(NSMutableArray *)jumpArr andNibName:(NSString *)nibName andSurveyId:(NSString *)surveyName andUser:(NSString *)myUser andKunnr:(NSString *)kunnr;
{
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    surveyQuestions = [[NSMutableArray alloc] init];
    selectedIndex   = [[NSMutableArray alloc] init];
    answerTexts   = [[NSMutableArray alloc] init];
    jumpQuestions = [[NSMutableArray alloc] init];
    surveyCreate = [[NSMutableArray alloc] init];
    prevQuestionList = [[NSMutableArray alloc] init];
    
    
    [surveyQuestions removeAllObjects];
    [selectedIndex removeAllObjects];
    [answerTexts removeAllObjects];
    [jumpQuestions removeAllObjects];
    [surveyCreate removeAllObjects];
    [prevQuestionList removeAllObjects];
    
    surveyQuestions = array;
    jumpQuestions = jumpArr;
    surveyId = surveyName;
    
    counter = 0;
    
    customerNo = kunnr;
    myk = myUser;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Anketi Onayla" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmSurvey)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmSurvey
{
    if ([surveyCreate count] == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Hiç bir cevap seçilmemiştir!" delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Anketi yaratmak istiyor musunuz?" delegate:self cancelButtonTitle:@"Evet" otherButtonTitles:@"Hayır", nil];
        
        [alert show];
        alert.tag = 2;
        return;
    }
}

-(void)getResponseWithString:(NSString *)myResponse andSender:(ABHSAPHandler *)me {
    
    [super stopAnimationOnView];
    
    UIAlertView *alert;
    
    NSMutableArray *responses = [ABHXMLHelper getValuesWithTag:@"E_RETURN" fromEnvelope:myResponse];
    NSMutableArray *message   = [ABHXMLHelper getValuesWithTag:@"E_MESSAGE" fromEnvelope:myResponse];
    
    if ([responses count] > 0)
    {
        
        
        if ([[responses objectAtIndex:0] isEqualToString: @"T"])
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Anket cevapları başarıyla gönderilmiştir." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            [alert show];
            alert.tag = 1;
            return;
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:[message objectAtIndex:0] delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Anket cevapları gönderilirken sorun olmuştur,lütfen tekrar deneyiniz." delegate:nil cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0) {
                [[self navigationController] popViewControllerAnimated:YES];
            }
            break;
        case 2:
            if (buttonIndex == 0) {
                [self sendSurveyAnswersToCrm];
            }
            else
            {
                return;
            }
            break;
        default:
            break;
    }
}

- (void)sendSurveyAnswersToCrm
{
    [super playAnimationOnView:self.view];
    
    if ([surveyCreate count] > 0) {
        
        for (int i = 0; i < [surveyCreate count]; i++) {
            
            questionId = [[surveyCreate objectAtIndex:i] questionId];
            answerId = [[surveyCreate objectAtIndex:i] answerId];
            value    = [[surveyCreate objectAtIndex:i] answerValue];
            
            if (longText == nil)
            {
                longText = [NSString stringWithFormat:@"%@%@%@%@%@",answerId,@",",questionId,@",",value];
            }
            else
            {
                longText = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",longText,@"*",answerId,@",",questionId,@",",value];
            }
            
        }
        
    }
    
    
    ABHSAPHandler *sapHandler = [[ABHSAPHandler alloc] initWithConnectionUrl:[ABHConnectionInfo getConnectionUrl]];
    [sapHandler setDelegate:self];
    [sapHandler prepRFCWithHostName:[ABHConnectionInfo getHostName] andClient:[ABHConnectionInfo getClient] andDestination:[ABHConnectionInfo getDestination] andSystemNumber:[ABHConnectionInfo getSystemNumber] andUserId:[ABHConnectionInfo getUserId] andPassword:[ABHConnectionInfo getPassword]
                         andRFCName:@"ZMOB_SET_SURVEY_ANSWERS"];
    
    [sapHandler addImportWithKey:@"I_SURVEY_ID" andValue:surveyId];
    [sapHandler addImportWithKey:@"I_SURVEY_ANSWERS" andValue:longText];
    [sapHandler addImportWithKey:@"I_UNAME" andValue:myk];
    [sapHandler addImportWithKey:@"I_KUNNR" andValue:customerNo];
    [sapHandler setDelegate:self];
    //    [sapHandler addTableWithName:tablePartners andColumns:columnsPartners];
    [sapHandler prepCall];
    //    }
}

#pragma tableView dataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [[[surveyQuestions objectAtIndex:counter] answers]count];
        default:
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    for (int j = 0; j < selectedIndex.count; j++) {
        NSUInteger num = [[selectedIndex objectAtIndex:j] intValue];
        
        if (num == indexPath.row && indexPath.section == 1)  {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            break;
        }
        
    }
    if (indexPath.section == 0) {
        
        
        int index = 0;
        index = [surveyQuestions count] - 1;
        
        if (counter > 0)
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"BackArrow.png"]];
            [cell.imageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTapped)];
            [tap setNumberOfTapsRequired:1];
            [cell.imageView setGestureRecognizers:[NSArray arrayWithObject:tap]];
        }
        
        if ([selectedIndex count] > 0 || [answerTexts count] > 0) {
            if (counter == index)
            {
                cell.accessoryView = nil;
                [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
            }
            else
            {
                UIButton *nextQuestion = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [nextQuestion setFrame:CGRectMake(0, 0, 110, 30)];
                [nextQuestion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [nextQuestion setTitle:@"Sonraki Soru" forState:UIControlStateNormal];
                [nextQuestion addTarget:self action:@selector(nextQuestion) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = nextQuestion;
            }
        }
        else
        {
            cell.accessoryView = nil;
        }
        
        [[cell textLabel]setFont:[UIFont boldSystemFontOfSize:13]];
        [[cell textLabel] setText:[[[surveyQuestions objectAtIndex:counter] question] texts]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setNumberOfLines:0];
        
        return cell;
    }
    else
    {
        //        for (int i = 0; i < [[[surveyQuestions objectAtIndex:counter] answers]count]; i++)
        //        {
        
        if ([[[[[surveyQuestions objectAtIndex:counter] answers]objectAtIndex:indexPath.row] answerTypes] isEqualToString:@"Text"])
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                textField = [[UITextField alloc] initWithFrame:CGRectMake(10,10,605,30)];
            }
            else
            {
                textField = [[UITextField alloc] initWithFrame:CGRectMake (10, 10, 290, 30)];
            }
            
            [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [textField setDelegate:self];
            [textField setPlaceholder:[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] texts]];
            [textField setReturnKeyType:UIReturnKeyDone];
            [cell setAccessoryView:textField];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            NSString *index = [NSString stringWithFormat:@"%d",indexPath.row];
            
            
            for (int b = 0; b<[answerTexts count]; b++) {
                if ([[[answerTexts objectAtIndex:b] objectAtIndex:2] isEqualToString: index])
                {
                    textField.text = [[answerTexts objectAtIndex:b] objectAtIndex:1];
                }
            }
        }
        else
        {
            //                for (int j = 0; j < [[[surveyQuestions objectAtIndex:counter] answers] count]; j++) {
            [[cell textLabel]setText:[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] texts]];
            [[cell textLabel]setFont:[UIFont systemFontOfSize:14]];
            //                }
        }
        
        //        }
        return cell;
        
    }
    
    //    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if ([[[[surveyQuestions objectAtIndex:indexPath.row] question]types] isEqualToString:@"Question"])
        {
            NSString *cellText = [[[surveyQuestions objectAtIndex:counter] question]texts];
            CGSize size = [cellText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280,999) lineBreakMode:UILineBreakModeWordWrap];
            NSLog(@"%f",size.height);
            
            if (size.height < 44.0f)
            {
                return 44.0f;
            }
            else
            {
                return size.height;
            }
        }
        else
        {
            return 44.0f;
        }
    }
    else
    {
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell *deselectCell;
        UITableViewCell *prevCell;
        
        int next;
        int prev;
        
        next = 0;
        prev = 0;
        
        if ([[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] answerTypes] isEqualToString:@"Text"])
        {
            
        }
        else
        {
            if ([selectedCell accessoryType] == UITableViewCellAccessoryNone)
            {
                if ([[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] answerTypes] isEqualToString:@"MultipleChoice"])
                    
                {
                    [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [selectedCell setSelected:NO];
                    [selectedIndex addObject:[NSNumber numberWithInt:indexPath.row]];
                    
                    CSSurveyCreate *surveyArray = [[CSSurveyCreate alloc] init];
                    surveyArray.idx = [NSString stringWithFormat:@"%d",counter];
                    surveyArray.questionId = [[[surveyQuestions objectAtIndex:counter] question] questionId];
                    surveyArray.answerId   = [[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] answerId];
                    surveyArray.answerValue   = [[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] questionId];
                    
                    [surveyCreate addObject:surveyArray];
                    [tableView reloadData];
                    return;
                }
                else
                {
                    for (int a = 0; a < [[[surveyQuestions objectAtIndex:counter] answers] count]; a++)
                    {
                        deselectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:a inSection:1]];
                        [deselectCell setAccessoryType:UITableViewCellAccessoryNone];
                        [deselectCell setSelected:NO];
                        [selectedIndex removeObject:[NSNumber numberWithInt:a]];
                        
                    }
                    for (int b = 0; b < [surveyCreate count]; b++)
                    {
                        if ([[[surveyCreate objectAtIndex:b] questionId] isEqualToString:[[[surveyQuestions objectAtIndex:counter] question] questionId]]) {
                            
                            [surveyCreate removeObjectAtIndex:b];
                            
                        }
                    }
                    
                    [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [selectedCell setSelected:NO];
                    [selectedIndex addObject:[NSNumber numberWithInt:indexPath.row]];
                    
                    CSSurveyCreate *surveyArray = [[CSSurveyCreate alloc] init];
                    surveyArray.idx = [NSString stringWithFormat:@"%d",counter];
                    surveyArray.questionId = [[[surveyQuestions objectAtIndex:counter] question] questionId];
                    surveyArray.answerId   = [[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] answerId];
                    surveyArray.answerValue   = [[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] questionId];
                    
                    [surveyCreate addObject:surveyArray];
                    [tableView reloadData];
                    return;
                    
                }
                
            }
            else
            {
                [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
                [selectedIndex removeObject:[NSNumber numberWithInt:indexPath.row]];
                for (int b = 0; b < [surveyCreate count]; b++)
                {
                    if ([[[surveyCreate objectAtIndex:b] questionId] isEqualToString:[[[surveyQuestions objectAtIndex:counter] question] questionId]] && [[[surveyCreate objectAtIndex:b] answerValue] isEqualToString:[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:indexPath.row] questionId]] ) {
                        
                        [surveyCreate removeObjectAtIndex:b];
                        
                    }
                }
                [tableView reloadData];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [textField superview];
    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    textField.text = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""])
    {
        UITableViewCell *cell = (UITableViewCell*) [textField superview];
        NSIndexPath *path = [tableView indexPathForCell:cell];
        NSString *string = [NSString stringWithFormat:@"%d",path.row];
        
        
        CSSurveyCreate *surveyArray = [[CSSurveyCreate alloc] init];
        surveyArray.idx = [NSString stringWithFormat:@"%d",counter];
        surveyArray.questionId = [[[surveyQuestions objectAtIndex:counter] question] questionId];
        surveyArray.answerId   = [[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:path.row] answerId];
        surveyArray.answerValue   = textField.text;
        
        [surveyCreate addObject:surveyArray];
        
        NSArray *array = [NSArray arrayWithObjects:[[[[surveyQuestions objectAtIndex:counter] answers] objectAtIndex:path.row] answerId],textField.text,string,nil];
        
        [answerTexts addObject:array];
        [tableView reloadData];
    }
    
}

- (void)nextQuestion
{
    
    if ([prevQuestionList count] == 0)
    {
        CSPrevQuestion *prev = [[CSPrevQuestion alloc] init];
        prev.countNumber = [NSString stringWithFormat:@"%d",counter ];
        [prevQuestionList addObject:prev];
    }
    
    int i = 0;
    
    if ([selectedIndex count] > 0) {
        i = [[selectedIndex objectAtIndex:0] intValue];
    }
    else
    {
        i = 0;
    }
    
    if ([[[[[surveyQuestions objectAtIndex:counter] answers]objectAtIndex:i] answerTypes] isEqualToString:@"SingleChoice"])
    {
        int index = 0;
        index =  [[selectedIndex objectAtIndex:0] intValue] + 1;
        
        int index2 = 0;
        
        for (int k = 0; k < [jumpQuestions count]; k++) {
            if ([[[[surveyQuestions objectAtIndex:counter] questionNo] uppercaseString] isEqualToString:[[jumpQuestions objectAtIndex:k] questionNumber]] && index == [[[jumpQuestions objectAtIndex:k] answerId] intValue]) {
                
                for (int l = 0; l < [surveyQuestions count]; l++) {
                    if ([[[[surveyQuestions objectAtIndex:l] questionNo] uppercaseString] isEqualToString:[[jumpQuestions objectAtIndex:k] jumpQuestion]]) {
                        
                        index2 = l;
                        break;
                    }
                }
                break;
            }
        }
        
        if (index2 == 0)
        {
            counter = counter + 1;
        }
        else
        {
            counter = index2;
        }
    }
    else if ([[[[[surveyQuestions objectAtIndex:counter] answers]objectAtIndex:i] answerTypes] isEqualToString:@"MultipleChoice"])
    {
        int index = 0;
        index =  [[selectedIndex objectAtIndex:0] intValue] + 1;
        
        int index2 = 0;
        
        for (int k = 0; k < [jumpQuestions count]; k++) {
            if ([[[[surveyQuestions objectAtIndex:counter] questionNo] uppercaseString] isEqualToString:[[jumpQuestions objectAtIndex:k] questionNumber]] && index == [[[jumpQuestions objectAtIndex:k] answerId] intValue]) {
                
                for (int l = 0; l < [surveyQuestions count]; l++) {
                    if ([[[[surveyQuestions objectAtIndex:l] questionNo] uppercaseString] isEqualToString:[[jumpQuestions objectAtIndex:k] jumpQuestion]]) {
                        
                        index2 = l;
                        break;
                    }
                }
                break;
            }
        }
        
        if (index2 == 0)
        {
            counter = counter + 1;
        }
        else
        {
            counter = index2;
        }
    }
    else
    {
        counter = counter + 1;
    }
    
    [selectedIndex removeAllObjects];
    [answerTexts removeAllObjects];
    
    CSPrevQuestion *prev = [[CSPrevQuestion alloc] init];
    prev.countNumber = [NSString stringWithFormat:@"%d",counter ];
    [prevQuestionList addObject:prev];
    
    [tableView reloadData];
}

- (void)backButtonTapped {
    
    textField.text = @"";
    [selectedIndex removeAllObjects];
    [answerTexts removeAllObjects];
    [prevQuestionList removeLastObject];
    [surveyCreate removeLastObject];
    
    NSString *index = [[prevQuestionList objectAtIndex:[prevQuestionList count] - 1] countNumber];
    counter = [index intValue];
    
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    
    [tableView reloadData];
    
    //    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    /*  limit to only numeric characters  */
//    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    for (int i = 0; i < [string length]; i++) {
//        unichar c = [string characterAtIndex:i];
//        if ([myCharSet characterIsMember:c]) {
//            return YES;
//        }
//    }
//
//    /*  limit the users input to only 9 characters  */
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    return (newLength > 9) ? NO : YES;
//}
@end
