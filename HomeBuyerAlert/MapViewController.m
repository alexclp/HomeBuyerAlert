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

@end

@implementation MapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	NSDictionary *params = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];

	[[Networking networking] properties:params withCompletion:^(NSArray *array, NSError *error) {
		
		if (error) {
			
		} else {
			NSLog(@"No error");
			
			NSMutableArray *temp = [NSMutableArray array];
			
			for (Property *property in array) {
				NSString *latitude = property.latitude;
				NSString *longitude = property.longitude;
				NSString *title = property.title;
				
				NSLog(@"Latitude = %@", latitude);
				NSLog(@"Longitude = %@", longitude);
				NSLog(@"Title = %@", title);
				
				[temp addObject:@{@"latitude": latitude, @"longitude": longitude, @"title": title}];
			}
			
			self.coordinates = temp.copy;
			
			[self.mapView addAnnotations:[self configureAnnotations]];
			
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

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id )annotation
{
	UIView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
	AnnotationView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] firstObject];
	calloutView.title.text = @"Title";
	calloutView.image.image = [UIImage imageNamed:@"placeholder.png"];
	
	DXAnnotationView *annotationView = (DXAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
	if (!annotationView) {
		annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
													  reuseIdentifier:NSStringFromClass([DXAnnotationView class])
															  pinView:pinView
														  calloutView:calloutView
															 settings:[DXAnnotationSettings defaultSettings]];
	}
	return annotationView;
}

@end
