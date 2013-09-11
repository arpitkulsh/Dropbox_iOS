//
//  ViewController.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "ViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OptionsViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize restClient;
- (void)viewDidLoad
{
    [super viewDidLoad];
    DBSession* dbSession =
    [[[DBSession alloc]
      initWithAppKey:@"p0sacpt4xlrizku"      // Dropbox App Key
      appSecret:@"dzhe5pg6efqe7ku"           // Dropbox app secret key
      root:kDBRootDropbox] // either kDBRootAppFolder or kDBRootDropbox
     autorelease];
    [DBSession setSharedSession:dbSession];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
- (DBRestClient *)restClient {   // dropbox client method to access shared Session
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}
// Link Your app to dropbox Account 

- (IBAction)didPressLink:(id)sender{
    if (![[DBSession sharedSession] isLinked]) {
       
		[[DBSession sharedSession] linkFromController:self];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        OptionsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"option"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
