//
//  MyFilesViewController.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "MyFilesViewController.h"
#import "MyFilesCustomCell.h"
#import "FolderViewController.h"
#import "MBProgressHUD.h"
#import <DropboxSDK/DropboxSDK.h>

@interface MyFilesViewController () <FolderDelegate>
{
    int tagFlag;
    ProgressHudPresenter *presenter;
}
@end

@implementation MyFilesViewController
@synthesize filesPathArray,myTable,file,restClient;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"My Files";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:53.0/255 green:103.0/255 blue:176.0/255 alpha:1];
    filesPathArray = [[NSMutableArray alloc] init];
    [self getFilesFromDictiory];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    presenter = [[ProgressHudPresenter alloc]init];
}
-(void)getFilesFromDictiory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSLog(@"files array %@", filePathsArray);
    
   [self.filesPathArray addObjectsFromArray:filePathsArray];
    NSLog(@"files array %@", self.filesPathArray);
    [self.tableView reloadData];
    if([filePathsArray count] == 0)
    {
        [[[[UIAlertView alloc]
           initWithTitle:@"No Files " message:@"There are No files in Local Storage"
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];

        noFiles.hidden=NO;
        self.tableView.hidden=NO;
    }
    else
    {
        noFiles.hidden=YES;
        self.tableView.hidden=NO;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

//-------------Upload file from dropbox --------------------------------------------

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    [[[[UIAlertView alloc]
       initWithTitle:@"File Uplaod" message:@"File uploaded successfully"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
    [presenter hideHud];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    
    NSLog(@"File upload failed with error - %@", error);
    [[[[UIAlertView alloc]
       initWithTitle:@"File Upload" message:@"File upload failed"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
    [presenter hideHud];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filesPathArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    MyFilesCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.title.text = [self.filesPathArray objectAtIndex:indexPath.row];
    cell.uploadButton.tag = indexPath.row;
    NSRange range = [cell.title.text rangeOfString:@"."];
    if (range.location != NSNotFound) {
        
        NSLog (@"Substring found at: %d", range.location);
        cell.imgIcon.image = [UIImage imageNamed:@"file-image.png"];
         [cell.uploadButton addTarget:self action:@selector(uploadfile:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        cell.imgIcon.image = [UIImage imageNamed:@"folder-image.png"];
        
    }
    return cell;
}

-(void)uploadfile:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    tagFlag = btn.tag;
    if (![[DBSession sharedSession] isLinked]) {
		[[[[UIAlertView alloc]
           initWithTitle:@"Link Account" message:@"Your dropbox account not linked with the App"
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
    } else {
        UIActionSheet *editMenu=[[UIActionSheet alloc]initWithTitle:@"Select" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Root Folder",@"Open Folder structure",nil ];
        [editMenu setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        [editMenu showInView:self.view];
        
    }
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:
            NSLog(@"Root Folder");
            NSString *filename = [self.filesPathArray objectAtIndex:tagFlag];
            NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                    NSUserDomainMask,
                                                                    YES);
            
            NSString *localPath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:filename];;
            NSLog(@"local Path ----> %@",localPath);
            NSString *destDir = @"/";
            [presenter presentHud:@"Uploading"];
            [[self restClient] uploadFile:filename toPath:destDir
                            withParentRev:nil fromPath:localPath];
            break;
        case 1:
            NSLog(@"Open Folder Structure");
           
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            FolderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"folderview"];
            [controller setMDelegate:self];
            controller.flag = [NSString stringWithFormat:@"3"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)setFolder:(FolderViewController *)pPopController withfile:(NSString *)fileString
{
    self.file = [NSString stringWithFormat:@"%@",fileString];
    NSLog(@"File Name ---> %@",self.file);
    if(!self.file)
    {
    NSString *filename = [self.filesPathArray objectAtIndex:tagFlag];
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    
    NSString *localPath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:filename];;
    NSLog(@"local Path ----> %@",localPath);
    NSString *destDir = self.file;
    [presenter presentHud:@"Uploading"];
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:localPath];
    }
    else
    {
        NSString *filename = [self.filesPathArray objectAtIndex:tagFlag];
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                NSUserDomainMask,
                                                                YES);
        
        NSString *localPath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:filename];;
        NSLog(@"local Path ----> %@",localPath);
        NSString *destDir = @"/";
        [presenter presentHud:@"Uploading"];
        [[self restClient] uploadFile:filename toPath:destDir
                        withParentRev:nil fromPath:localPath];
    }
}
@end
