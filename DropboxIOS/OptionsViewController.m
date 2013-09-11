//
//  OptionsViewController.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "OptionsViewController.h"
#import "FolderViewController.h"
@interface OptionsViewController ()

@end

@implementation OptionsViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    UIImage *chosenImage = [UIImage imageNamed:@"upload-icon.png"];
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"upload-icon.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)browseFolder:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    FolderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"folderview"];
    controller.flag = [NSString stringWithFormat:@"1"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)browseDownlaod:(id)sender
{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    FolderViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"folderview"];
    controller.flag = [NSString stringWithFormat:@"2"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
