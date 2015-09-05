//
//  ListViewCell.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 05.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *details;
@property (nonatomic, weak) IBOutlet UILabel *price;

@end
