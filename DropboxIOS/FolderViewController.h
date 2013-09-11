//
//  FolderViewController.h
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "ProgressHudPresenter.h"


@class FolderViewController;

@protocol FolderDelegate       // Delegate Method changes after uploading
-(void)setFolder:(FolderViewController*)pPopController withfile:(NSString*)fileString;
@end

@interface FolderViewController : UITableViewController<DBRestClientDelegate>
{
    
    DBRestClient *restClient;
    NSMutableArray *folderStructure;
    NSString *flag;
    id<FolderDelegate>mDelegate;
    
}
@property(nonatomic,retain) DBRestClient *restClient;

@property (nonatomic,retain) NSMutableArray *folderStructure;
@property (nonatomic, retain) id <FolderDelegate> mDelegate;
@property (nonatomic,retain) NSString *flag;

@end
