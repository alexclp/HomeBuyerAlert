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

@interface ListViewController ()

@property (nonatomic, strong) NSArray *properties;

@end

@implementation ListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[Networking networking] properties:self.requestParams withCompletion:^(NSArray *array, NSError *error) {
		self.properties = [NSArray arrayWithArray:array];
		
		[self.tableView reloadData];
		
	}];
}

#pragma mark UITableView Data Source

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"SimpleTableCell";
	
	ListViewCell *cell = (ListViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	if (cell == nil)
	{
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	// Set properties here
	
	Property *current = [self.properties objectAtIndex:indexPath.row];
	
	cell.title.text = current.title;
	cell.details.text = current.details;
	cell.price.text = current.price;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.properties.count;
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end