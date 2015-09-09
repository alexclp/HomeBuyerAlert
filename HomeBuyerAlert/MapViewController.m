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
#import "PropertyAnnotation.h"
#import "AnnotationView.h"
#import "DXAnnotationView.h"
#import "DXAnnotationSettings.h"

@interface MapViewController ()

@property (nonatomic, strong) NSArray *coordinates;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *properties;

@end

@implementation MapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	NSDictionary *params = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];

	[[Networking networking] properties:params withCompletion:^(NSArray *array, NSError *error) {
		
		if (error) {
			
		} else {
			
			NSMutableArray *temp = [NSMutableArray array];
			
			self.properties = array;
			
			for (Property *property in self.properties) {
				NSString *latitude = property.latitude;
				NSString *longitude = property.longitude;
				NSString *title = property.title;
				
				[temp addObject:@{@"latitude": latitude, @"longitude": longitude, @"title": title}];
			}
			
			self.coordinates = temp.copy;
			
			self.index = 0;
			[self.mapView addAnnotations:[self configureAnnotations]];
			[self zoomToLocation];
			
		}
	}];
}

- (NSArray *)configureAnnotations {
	
	NSMutableArray *annotations = [NSMutableArray array];
	
	for (NSDictionary *location in self.coordinates) {
		
		CLLocationCoordinate2D coord;
		coord.latitude = [[location objectForKey:@"latitude"] doubleValue];
		coord.longitude = [[location objectForKey:@"longitude"] doubleValue];
		
		PropertyAnnotation *annotation = [[PropertyAnnotation alloc] initwithCoordinate:coord andTitle:[location objectForKey:@"title"]];
		[annotations addObject:annotation];
	}
	
	return annotations;
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id)annotation
{
	Property *current = [self.properties objectAtIndex:self.index];
	UIView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
	pinView.frame = CGRectMake(-5, 0, 34, 34);
	AnnotationView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] firstObject];
	calloutView.title.text = current.title;
	calloutView.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.imageURL]]];
	
	DXAnnotationView *annotationView = (DXAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
	if (!annotationView) {
		annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
													  reuseIdentifier:NSStringFromClass([DXAnnotationView class])
															  pinView:pinView
														  calloutView:calloutView
															 settings:[DXAnnotationSettings defaultSettings]];
	}
	
	self.index ++;
	
	return annotationView;
}

- (void)zoomToLocation {
	NSDictionary *firstLocation = [self.coordinates objectAtIndex:0];
	MKCoordinateRegion region;
	region.center.latitude = [[firstLocation objectForKey:@"latitude"] doubleValue];
	region.center.longitude = [[firstLocation objectForKey:@"longitude"] doubleValue];
	
	region.span.latitudeDelta = 30.0;
	region.span.longitudeDelta = 30.0;
	
	[self.mapView setRegion:region animated:YES];
}

@end
