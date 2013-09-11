//
//  MyFilesViewController.h
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MyFilesViewController : UITableViewController<DBRestClientDelegate,UIActionSheetDelegate>
{
    IBOutlet UILabel *noFiles;
    IBOutlet UITableView *myTable;
    NSMutableArray *filesPathArray;
    DBRestClient *restClient;
    NSString *file;
}
@property(nonatomic,retain) NSMutableArray *filesPathArray;
@property(nonatomic,retain) NSString *file;
@property(retain,nonatomic) DBRestClient *restClient;
@property (nonatomic,retain) IBOutlet UITableView *myTable;
@end
