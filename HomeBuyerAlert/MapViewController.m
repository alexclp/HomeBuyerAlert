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
#import "MBProgressHUD.h"
#import "DetailsViewController.h"

@interface MapViewController ()

@property (nonatomic, strong) NSArray *coordinates;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *properties;

@property (nonatomic, strong) NSString *selectedPropertyID;

@end

@implementation MapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Map View";
	
	
	NSDictionary *params = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];

	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] properties:params withCompletion:^(NSArray *array, NSError *error) {
		
		if (error) {
			
		} else {
			
			if (array.count) {
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
				[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
			} else {
				
			}
			
			
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationTapped) name:@"Annotation Tapped" object:nil];
	
	
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
	
	// Setting the title
	
	calloutView.title.text = current.title;
	calloutView.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:current.imageURL]]];
	
	// Setting the price here
	
	NSNumber *value = [NSNumber numberWithFloat:current.price.doubleValue];
	NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
	calloutView.price.text = [@"$" stringByAppendingString:modelNumberString];
	calloutView.propertyID = [NSString stringWithFormat:@"%ld", self.index];
	
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

#pragma mark User Interaction

- (void)annotationTapped {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.selectedPropertyID = [defaults objectForKey:@"PropertyID"];
	
	[self performSegueWithIdentifier:@"showDetailsFromMap" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showDetailsFromMap"]) {
		Property *current = [self.properties objectAtIndex:self.selectedPropertyID.intValue];
		NSLog(@"INDEX: %d", self.selectedPropertyID.intValue);
		
		DetailsViewController *vc = [segue destinationViewController];
		vc.selectedProperty = current.code;
	}
}

@end
