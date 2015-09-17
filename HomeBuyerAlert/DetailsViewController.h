//
//  DetailsViewController.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 04.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWPhotoBrowser.h"

@interface DetailsViewController : UIViewController <MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *selectedProperty;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
