//
//  ProgressHudPresenter.h
//  Notch
//
//  Created by Eric Wilson on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHudPresenter : NSObject

@property(nonatomic, retain) NSString* title;

-(void)presentHud;

-(void)hideHud;
-(void)presentHud:(NSString *)title;

@end
