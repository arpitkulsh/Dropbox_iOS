//
//  CustomCell.h
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 02/09/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
{
    IBOutlet UIImageView *img;
    IBOutlet UILabel *title;
    IBOutlet UIButton *downloadButton;
}
@property(nonatomic,weak) IBOutlet UIImageView *img;
@property (nonatomic,weak) IBOutlet UILabel *title;
@property (nonatomic,weak) IBOutlet UIButton *downloadButton;
@end
