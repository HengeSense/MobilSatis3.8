//
//  EBMenuSelectedDelegate.h
//  EfesBayi
//
//  Created by alp keser on 4/11/13.
//  Copyright (c) 2013 alp keser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMenuSelectedDelegate : NSObject

@end
@protocol CSMenuSelectedDelegate

- (void)profileSelected;
- (void)customerSelected;
- (void)locationSelected;
@end