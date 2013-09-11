//
//  ViewController.h
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
@interface ViewController : UIViewController<DBRestClientDelegate>   // DB Client Delegate
{
  DBRestClient *restClient;     // Dropbox Client object to access the services
}
@property(retain,nonatomic) DBRestClient *restClient;
- (IBAction)didPressLink:(id)sender;
@end
