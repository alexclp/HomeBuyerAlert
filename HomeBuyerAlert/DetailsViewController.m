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

@implementation DetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSLog(@"Selected property: %@", self.selectedProperty);
	
	[[Networking networking] detailsOfProperty:self.selectedProperty withCompletion:^(PropertyDetail *details, NSError *error) {
		if (error) {
			
		} else {
			
		}
	}];
}

- (UIImage *)createThumbnailFromImage:(UIImage *)originalImage {
	CGSize destinationSize = CGSizeMake(150, 150);
	UIGraphicsBeginImageContext(destinationSize);
	[originalImage drawInRect:CGRectMake(0, 0, destinationSize.width, destinationSize.height)];
	UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return thumb;
}



@end
