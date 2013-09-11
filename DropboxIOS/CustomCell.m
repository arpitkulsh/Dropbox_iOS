//
//  CustomCell.m
//  DropboxIOS
//
//  Created by Arpit Kulshrestha on 02/09/13.
//  Copyright (c) 2013 InnnovationM. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize img,title,downloadButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
