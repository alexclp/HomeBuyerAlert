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
#import "DetailsCustomCell.h"

static NSString * const DetailsCellIdentifier = @"DetailsCustomCell";

@interface DetailsViewController ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *thumbs;
@property (nonatomic, strong) PropertyDetail *details;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Details";
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] detailsOfProperty:self.selectedProperty withCompletion:^(PropertyDetail *details, NSError *error) {
		if (error) {
			
		} else {
			
			self.details = details;
			[self.tableView reloadData];
			
			
			[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		}
	}];

	NSLog(@"Selected property: %@", self.selectedProperty);
}

- (void)configurePhotoBrowser:(NSArray *)photoLinks {
	NSMutableArray *photos = [NSMutableArray array];
	NSMutableArray *thumbs = [NSMutableArray array];
	
	for (NSString *url in photoLinks) {
		UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
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

- (NSString *)formatPrice:(NSString *)price {
	NSNumber *value = [NSNumber numberWithFloat:price.floatValue];
	NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
	
	return [@"$" stringByAppendingString:modelNumberString];
}

#pragma mark User Interaction

- (void)tapDetected {
	NSLog(@"Tap");

	MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud1.labelText = @"Getting pictures";
	
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
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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

#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows;
	if (self.details) {
		rows = 8;
	} else {
		rows = 0;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return [self basicCellAtIndexPath:indexPath];
}

- (DetailsCustomCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
	DetailsCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DetailsCellIdentifier forIndexPath:indexPath];
	[self configureBasicCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureBasicCell:(DetailsCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		NSString *price = [self formatPrice:self.details.price];
		cell.title.text = price;
		
		NSString *type = self.details.type;
		cell.subtitle.text = type;
		
		
	} else if (indexPath.row == 1) {
		cell.title.text = @"Description";
		cell.subtitle.text = self.details.details;
		
	} else if (indexPath.row == 2) {
		cell.title.text = @"Address";
		cell.subtitle.text = self.details.title;
		
	} else if (indexPath.row == 3) {
		
		cell.title.text = @"Details";
		
		NSString *size = [@"Size: " stringByAppendingString:self.details.size];
		size = [size stringByAppendingString:@"sq ft"];
		
		NSString *bathrooms = [@"Bathrooms: " stringByAppendingString:self.details.bathrooms];
		NSString *garage = [@"Garage: " stringByAppendingString:self.details.garage];
		NSString *bedrooms = [@"Bedrooms: " stringByAppendingString:self.details.bedrooms];
		
		cell.subtitle.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", size, bathrooms, garage, bedrooms];
	} else if (indexPath.row == 4) {
		cell.title.text = self.details.userName;
		cell.subtitle.text = @"";
	} else if (indexPath.row == 5) {
		cell.title.text = self.details.email;
		cell.subtitle.text = @"";
	} else if (indexPath.row == 6) {
		cell.title.text = self.details.website;
		cell.subtitle.text = @"";
	} else if (indexPath.row == 7) {
		cell.title.text = self.details.phone;
		cell.subtitle.text = @"";
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.details.pics objectAtIndex:0]]]];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake (100, 100, 375, 248);
//	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
//	singleTap.numberOfTapsRequired = 1;
	imageView.userInteractionEnabled = YES;
//	[imageView addGestureRecognizer:singleTap];
	
	return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 248;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
	static DetailsCustomCell *sizingCell = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sizingCell = [self.tableView dequeueReusableCellWithIdentifier:DetailsCellIdentifier];
	});
 
	[self configureBasicCell:sizingCell atIndexPath:indexPath];
	return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
	sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
	[sizingCell setNeedsLayout];
	[sizingCell layoutIfNeeded];
 
	CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	
	if (indexPath.row == 5) {
		[self showEmail];
	} else if (indexPath.row == 6) {
		[self makeCall];
	} else if (indexPath.row == 7) {
		[self openWebsite];
	}
}

#pragma mark Contact

- (void)openWebsite {
	
	if (![self.details.website isEqual:@""]) {
		NSURL *url = [NSURL URLWithString:self.details.website];
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)makeCall {
	NSURL *callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.details.phone]];

	if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
		[[UIApplication sharedApplication] openURL:callUrl];
	} else {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"This function is only available on the iPhone"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

- (void)showEmail {
	// Email Subject
	NSString *emailTitle = @"";
	// Email Content
	NSString *messageBody = @"=";
	// To address
	NSArray *toRecipents = [NSArray arrayWithObject:self.details.email];
	
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	mc.mailComposeDelegate = self;
	[mc setSubject:emailTitle];
	[mc setMessageBody:messageBody isHTML:NO];
	[mc setToRecipients:toRecipents];
	
	// Present mail view controller on screen
	[self presentViewController:mc animated:YES completion:NULL];
	
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail sent failure: %@", [error localizedDescription]);
			break;
		default:
			break;
	}
	
	// Close the Mail Interface
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
