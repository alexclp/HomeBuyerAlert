//
//  MapViewController.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 04.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "MapViewController.h"
#import "Networking.h"
#import "Property.h"

@interface MapViewController ()

@property (nonatomic, strong) NSArray *coordinates;

@end

@implementation MapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSDictionary *params = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];
	
	[[Networking networking] properties:params withCompletion:^(NSArray *array, NSError *error) {
		
		if (error) {
			
		} else {
			
			NSMutableArray *temp = [NSMutableArray array];
			
			for (Property *property in array) {
				NSString *latitude = property.latitude;
				NSString *longitude = property.longitude;
				NSString *title = property.title;
				
				[temp addObject:@{@"latitude": latitude, @"longitude": longitude, @"title": title}];
			}
			
			self.coordinates = temp.copy;
			
			
			
		}
	}];
}
/*
- (NSArray *)configureAnnotations {
	
	NSMutableArray *annotations = [NSMutableArray array];
	
	for (NSDictionary *location in self.coordinates) {
		
		CLLocationCoordinate2D coord;
		coord.latitude = [[location objectForKey:@"latitude"] doubleValue];
		coord.longitude = [[location objectForKey:@"longitude"] doubleValue];
		
		s
	}
	
}
*/



@end
