//
//  CSAppDelegate.h
//  CrmServisPrototype
//
//  Created by ABH on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "customNavigationController.h"
@class CSMasterViewController;
@class CSProfileViewController;
@class CSUser;
@interface CSAppDelegate : UIResponder <UIApplicationDelegate> {
    int timestamp;
    
}
@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) Reachability *internetReach;
@property (nonatomic, retain)  NSString *token;
@property (nonatomic, retain) NSString *otherMykUser;
@property (nonatomic, retain) NSString *defaultMyk;
@property (nonatomic, retain)  UISplitViewController *splitViewController;
@property (nonatomic, retain)  CSMasterViewController *masterViewController;
@property (nonatomic, retain)  CSProfileViewController *profileViewController;
@property BOOL newVersion;

- (void)loginConfirmed:(CSUser *)myUser;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
