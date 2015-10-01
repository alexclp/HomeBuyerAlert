//
//  ListViewController.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 04.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "ListViewController.h"
#import "Networking.h"
#import "Property.h"
#import "ListViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailsViewController.h"
#import "MBProgressHUD.h"
#import "GTMNSString+HTML.h"

@interface ListViewController ()

@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation ListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"List view";
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] properties:self.requestParams withCompletion:^(NSArray *array, NSError *error) {
		self.properties = [NSArray arrayWithArray:array];
		
		[self.tableView reloadData];
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		
	}];
}

#pragma mark UITableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"ListViewCell";
	
	ListViewCell *cell = (ListViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	// Set properties here
	
	Property *current = [self.properties objectAtIndex:indexPath.row];
	
	cell.title.text = current.title;
	cell.details.text = [current.details gtm_stringByUnescapingFromHTML];
	cell.details.text = [cell.details.text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

	float priceFloat = current.price.floatValue;
	NSNumber *value = [NSNumber numberWithFloat:priceFloat];
	NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
	
	cell.price.text = modelNumberString;
	cell.price.text = [@"$" stringByAppendingString:cell.price.text];
	
	[cell.image sd_setImageWithURL:[NSURL URLWithString:current.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.properties.count;
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	self.selectedIndex = indexPath.row;

	[self performSegueWithIdentifier:@"showDetails" sender:self];
}

#pragma mark User Interaction

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showDetails"]) {
		
		Property *current = [self.properties objectAtIndex:self.selectedIndex];
		
		DetailsViewController *vc = [segue destinationViewController];
		vc.selectedProperty = current.code;
	}
}

@end
