//
//  FolderViewController.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "FolderViewController.h"
#import "CustomCell.h"
#import "ProgressHudPresenter.h"
@interface FolderViewController ()
{
    
    NSString *filepath;
    ProgressHudPresenter *presenter;
    
}
@property(nonatomic,retain) NSString *filepath;
@end

@implementation FolderViewController
@synthesize restClient,folderStructure,filepath,flag,mDelegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    folderStructure = [[NSMutableArray alloc] init];
    [[self restClient] loadMetadata:@"/"];
    self.navigationItem.title = @"Dropbox Folder";
     self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:53.0/255 green:103.0/255 blue:176.0/255 alpha:1];
    NSLog(@"In ViewDidlaod");
    if([flag isEqualToString:@"3"])
    {
    // Upload button on evrey time for path selection
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleDone target:self action:@selector(backButton)];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select" message:@"Choose Folder for file upload"  delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2.0];
    }
    else{
         
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dismissAlertView:(UIAlertView *)alertView{
	
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)backButton
{
    [mDelegate setFolder:self withfile:self.filepath];
    NSLog(@"FilePath---> %@",self.filepath);
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)loadAgain:(id)sender
{
    NSLog(@"File Path ---> %@",self.filepath);
    if(![self.filepath isEqualToString:@""])
    {
    int len = [self.filepath length]; // reverse the string
    NSMutableString *reverseName = [[NSMutableString alloc] initWithCapacity:len];
    
    for(int i=len-1;i>=0;i--)
    {
        [reverseName appendFormat:[NSString stringWithFormat:@"%c",[self.filepath characterAtIndex:i]]];
        
    }

    NSRange r = [reverseName rangeOfString:@"/"]; 
    NSString *st = [reverseName substringFromIndex:r.location];
    int leng = [st length];
    
    NSMutableString *rName = [[NSMutableString alloc] initWithCapacity:leng];
    
    for(int i=leng-1;i>0;i--)
    {
        [rName appendFormat:[NSString stringWithFormat:@"%c",[st characterAtIndex:i]]];
        
    }
    self.filepath = [NSString stringWithFormat:@"%@",rName];
    NSLog(@"After Changing FilePath --->%@",self.filepath);
    if([filepath isEqualToString:@"/"])
    {
      [[self restClient] loadMetadata:@"/"];
    }
    else
    {
    [[self restClient] loadMetadata:self.filepath];
    }
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    if([flag isEqualToString:@"3"])
    {
      [self.navigationItem setHidesBackButton:YES];
    }
    else{
         [self.navigationItem setHidesBackButton:NO];
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

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
     [self.folderStructure removeAllObjects];
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"t%@", file.filename);
            [self.folderStructure addObject:file.filename];
        }
    }
    NSLog(@"--> %@",self.folderStructure);
    [self.tableView reloadData];
  
    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
   
}

-(void)hideHud
{
   [presenter hideHud];
}
- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
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
    return [self.folderStructure count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.title.text = [self.folderStructure objectAtIndex:indexPath.row];
    cell.downloadButton.tag = indexPath.row;
    [cell.downloadButton addTarget:self action:@selector(downloadfile:) forControlEvents:UIControlEventTouchUpInside];
    NSRange range = [cell.title.text rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSLog (@"Substring found at: %d", range.location);
    
        cell.img.image = [UIImage imageNamed:@"file-image.png"];
        if([flag isEqualToString:@"2"])
        {
        cell.downloadButton.hidden = FALSE;
        }
    }else{
        cell.img.image = [UIImage imageNamed:@"folder-image.png"];
        cell.downloadButton.hidden =TRUE;
    }
   return cell;
}
-(void)downloadfile:(id)sender
{
    NSLog(@"File Sender Tag --> %@",sender);
    UIButton *button1 = (UIButton*)sender;
    int w = button1.tag;
    if(!self.filepath)
    {
        if (![[DBSession sharedSession] isLinked]) {
            [[[[UIAlertView alloc]
               initWithTitle:@"Link Account" message:@"Your dropbox account not linked with the App"
               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
              autorelease]
             show];
        } else {
            NSString *dropboxPath = [NSString stringWithFormat:@"/%@",[self.folderStructure objectAtIndex:w]];
            NSRange range = [dropboxPath rangeOfString:@"."];
            NSString *path = [dropboxPath substringToIndex:range.location];
            NSLog(@"Path ---> %@",path);
            NSString *type = [dropboxPath substringFromIndex:range.location];
            NSLog(@"Type---%@",type);
            NSString *localPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",type] ofType:[NSString stringWithFormat:@"%@",type]];
            [presenter presentHud:@"Downloading"];
            [[self restClient] loadFile:dropboxPath intoPath:localPath];
        }

    }
}
//------------Download file from dropbox -------------------------------------------

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    [presenter hideHud];
    NSLog(@"File loaded into path: %@", localPath);
    [[[[UIAlertView alloc]
       initWithTitle:@"File Download" message:@"File Downloaded Successfully"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    [presenter hideHud];
    NSLog(@"There was an error loading the file - %@", error);
    [[[[UIAlertView alloc]
       initWithTitle:@"File Downlaod" message:@"File Download Failed with error"
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
}

-(void)viewDidAppear:(BOOL)animated
{
    presenter = [[ProgressHudPresenter alloc]init];
    [presenter presentHud:@"Loading"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!self.filepath)
    {
        NSString *data = [NSString stringWithFormat:@"/%@",[self.folderStructure objectAtIndex:indexPath.row]];
        NSRange range = [data rangeOfString:@"."];
        if (range.location != NSNotFound) {
            
        }else{
            [[self restClient] loadMetadata:data]; // downlaod file from root folder
            self.filepath = [NSString stringWithFormat:@"%@",data];
            NSLog(@"FilePath in if ---> %@",self.filepath);
        }
    }
    else
    {
        // downlaod from file / folder structures
        
        NSLog(@"FilePath in else ---> %@",self.filepath);
        
        NSString *data1 = [NSString stringWithFormat:@"%@/%@",self.filepath,[self.folderStructure objectAtIndex:indexPath.row]];
        NSRange r = [data1 rangeOfString:@"."];
        self.filepath = [NSString stringWithFormat:@"%@",data1];
        NSLog(@"Data 1 file path ---> %@  %@",self.filepath,data1);
        if (r.location != NSNotFound) {
            
        }else{
            [[self restClient] loadMetadata:data1];
        }
    }
    [self viewWillAppear:YES];  // For adding Button 
}


@end
