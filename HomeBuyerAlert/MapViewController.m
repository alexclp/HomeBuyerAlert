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

@interface MapViewController ()

@property (nonatomic, strong) NSArray *coordinates;

@end

@implementation MapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self placeTestPin];
	/*
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
			
			[self.mapView addAnnotations:[self configureAnnotations]];
			
		}
	}];*/
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
	/*
	MKPinAnnotationView *pinView = nil;
	static NSString *defaultPinID = @"ReusedPin";
	pinView = (MKPinAnnotationView*)[mVdequeueReusableAnnotationViewWithIdentifier:defaultPinID];
	if ( pinView == nil )
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
	if (((PinAnnotationView*)annotation).tag == 0 )
	{
		pinView.pinColor = MKPinAnnotationColorPurple;
	}
	else {
		pinView.pinColor = MKPinAnnotationColorRed;
	}
	pinView.canShowCallout = YES;
	pinView.animatesDrop = YES;
	UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, 34, 34)];
	UIImage *pinImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"]];
	pinImageView.image = pinImage;
	[pinImage release];
	[pinView addSubview:pinImageView];
	[pinImageView release];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	btn.tag = ((PinAnnotationView*)annotation).tag;
	pinView.rightCalloutAccessoryView = btn;
	return pinView;
	*/
	
	static NSString *defaultPinID = @"ReusedPin";
	MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
	
	if (!pinView) {
		pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
	}
	
	pinView.pinColor = MKPinAnnotationColorRed;
	
	pinView.animatesDrop = YES;
	
	UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, 34, 34)];
	UIImage *pinImage = [UIImage imageNamed:@"placeholder.png"];
	pinImageView.image = pinImage;
	[pinView addSubview:pinImageView];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pinView.rightCalloutAccessoryView = btn;
	return pinView;

}

- (void)placeTestPin {
	CLLocationCoordinate2D coord;
	coord.latitude = 53.58448;
	coord.longitude = -8.93772;
	PropertyAnnotation *annot = [[PropertyAnnotation alloc] initwithCoordinate:coord andTitle:@"Title"];
	[self.mapView addAnnotation:annot];
}

@end
