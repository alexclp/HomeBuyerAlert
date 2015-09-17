//
//  DetailsCustomCell.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 17.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsLabel.h"

@interface DetailsCustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet DetailsLabel *title;
@property (nonatomic, weak) IBOutlet DetailsLabel *subtitle;

@end
