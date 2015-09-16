//
//  DetailsViewController.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 04.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "DetailsViewController.h"
#import "Networking.h"
#import "PropertyDetail.h"
#import "MBProgressHUD.h"

@interface DetailsViewController ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *thumbs;
@property (nonatomic, strong) PropertyDetail *details;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
	singleTap.numberOfTapsRequired = 1;
	self.imageView.userInteractionEnabled = YES;
	[self.imageView addGestureRecognizer:singleTap];

	NSLog(@"Selected property: %@", self.selectedProperty);
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] detailsOfProperty:self.selectedProperty withCompletion:^(PropertyDetail *details, NSError *error) {
		if (error) {
			
		} else {
			
			UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[details.pics objectAtIndex:0]]]];
			self.imageView.image = image;
			
			self.details = details;
			
			[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		}
	}];
	
}

- (void)configurePhotoBrowser:(NSArray *)photoLinks {
	NSMutableArray *photos = [NSMutableArray array];
	NSMutableArray *thumbs = [NSMutableArray array];
	
	NSLog(@"Photo links: %@", photoLinks);
	
	for (NSString *url in photoLinks) {
		UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
		NSLog(@"Image: %@", image);
		[photos addObject:[MWPhoto photoWithImage:image]];
		[thumbs addObject:[MWPhoto photoWithImage:[self createThumbnailFromImage:image]]];
	}
	
	self.photos = photos;
	self.thumbs = thumbs;
}

- (UIImage *)createThumbnailFromImage:(UIImage *)originalImage {
	CGSize destinationSize = CGSizeMake(150, 150);
	UIGraphicsBeginImageContext(destinationSize);
	[originalImage drawInRect:CGRectMake(0, 0, destinationSize.width, destinationSize.height)];
	UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return thumb;
}

#pragma mark User Interaction

- (void)tapDetected {
	NSLog(@"Tap");

	[self configurePhotoBrowser:self.details.pics];

	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
	browser.displayActionButton = NO;
	browser.displayNavArrows = YES;
	browser.displaySelectionButtons = NO;
	browser.alwaysShowControls = YES;
	browser.zoomPhotosToFill = YES;
	browser.enableGrid = YES;
	browser.startOnGrid = YES;
	browser.enableSwipeToDismiss = NO;
	browser.autoPlayOnAppear = NO;
	[browser setCurrentPhotoIndex:0];

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
	nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:nc animated:YES completion:nil];

}

#pragma mark MKPhotoBrowser Delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
	return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
	if (index < self.photos.count) {
		return [self.photos objectAtIndex:index];
	}
	return nil;
}

@end
