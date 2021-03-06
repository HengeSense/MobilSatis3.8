//
//  CSLoginViewController.h
//  CrmServisPrototype
//
//  Created by ABH on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"
#import "CSUser.h"
#import "ABHSAPHandler.h"
#import "CSNewCoolerList.h"
#import "CSTowerAndSpoutList.h"
#import "CSPasswordChangeViewController.h"
#import "CSLoctionHandlerViewController.h"
#import "CSMasterViewController.h"
#import "CSAppDelegate.h"

@class CSDetailViewController;
@class CSMasterViewController;

@interface CSLoginViewController : CSBaseViewController<UINavigationControllerDelegate,ABHSAPHandlerDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *infoButton;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *passwordLabel;
    IBOutlet UIImageView *logoView;
    UITextField *activeField;
    CDOUser *loginEntity;
    UIBarButtonItem *loginButton;
    
    UISplitViewController *splitViewController ;
    CSMasterViewController *masterViewController;
}

@property (nonatomic, retain) UITextField *username;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) NSMutableArray *crmServerIpList;
@property (nonatomic, retain) NSMutableArray *crmSystemNumberList;
@property (nonatomic, retain) CDOUser *loginEntity;
@property int crmServerIpCount;
@property int crmSystemNumberCount;
@property (nonatomic, retain) NSString *isAdmin;
@property (nonatomic, retain) NSString *udId;
@property (nonatomic, retain) NSString *connectWithMyk;

-(IBAction)login;
-(IBAction)showInfo;
-(IBAction)forgotMyPassword;
-(BOOL)loginToSAPWithUserName:(NSString*)myUserName andPassword:(NSString*)myPassword;
-(BOOL)checkUserRegisterationWithResponse:(NSString*)myResponse;
- (IBAction)makeKeyboardGoAway;
-(IBAction)changeUserPassword:(id)sender;
- (void)downloadUpdatedApp;
+ (id)getTheLoginViewBack;
@end

@protocol LoginDelegate<NSObject>

@end
