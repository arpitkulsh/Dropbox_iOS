//
//  UploadOptionViewController.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "UploadOptionViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "FolderViewController.h"
#import "ProgressHudPresenter.h"

@interface UploadOptionViewController () <FolderDelegate>
{
    ProgressHudPresenter *presenter;
}
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic) UIImageView *imageView;

@end

@implementation UploadOptionViewController
@synthesize restClient,file;
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
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    presenter = [[ProgressHudPresenter alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:NO];
   self.navigationItem.title = @"Folders";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)photoLibrary:(id)sender
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FolderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"folderview"];
   [controller setMDelegate:self];
    controller.flag = [NSString stringWithFormat:@"3"];
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)setFolder:(FolderViewController *)pPopController withfile:(NSString *)fileString
{
    self.file = [NSString stringWithFormat:@"%@",fileString];
    NSLog(@"File Name ---> %@",self.file);
    NSInteger randomNumber = arc4random() % 100;
    NSString *filename = [NSString stringWithFormat:@"MyiPhonepic-%d.png",randomNumber];
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    
    NSString *localPath = [[pathList objectAtIndex:0] stringByAppendingPathComponent:@"image.png"];;
    NSLog(@"local Path ----> %@",localPath);
    NSString *destDir = self.file;
    [presenter presentHud:@"Uploading"];
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:localPath];
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
    [presenter hideHud];
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    [[[[UIAlertView alloc]
       initWithTitle:@"File Uplaod" message:@"File uploaded successfully"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    [presenter hideHud];
    NSLog(@"File upload failed with error - %@", error);
    [[[[UIAlertView alloc]
       initWithTitle:@"File Upload" message:@"File upload failed"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
}
@end
