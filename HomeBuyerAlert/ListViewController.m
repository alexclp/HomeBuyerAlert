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

@interface ListViewController ()

@property (nonatomic, strong) NSArray *properties;

@end

@implementation ListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[Networking networking] properties:self.requestParams withCompletion:^(NSArray *array, NSError *error) {
		self.properties = [NSArray arrayWithArray:array];
		
	}];
}

@end
