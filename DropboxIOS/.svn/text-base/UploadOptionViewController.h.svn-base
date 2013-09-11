//
//  UploadOptionViewController.h
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 30/08/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface UploadOptionViewController : UIViewController<UIImagePickerControllerDelegate,DBRestClientDelegate,UINavigationControllerDelegate>
{
  DBRestClient *restClient;
    NSString *file;
}
-(IBAction)photoLibrary:(id)sender;
@property (nonatomic,retain) NSString *file;
@property(retain,nonatomic) DBRestClient *restClient;
@end
