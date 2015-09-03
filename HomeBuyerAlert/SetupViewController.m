//
//  SetupViewController.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "SetupViewController.h"
#import "Networking.h"
#import "ActionSheetStringPicker.h"

@interface SetupViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation SetupViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"Setup Controller");
	
	self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.view addSubview:self.activityView];
	[self.activityView startAnimating];
	
	[[Networking networking] activeProvincesWithCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.provinces = [NSArray arrayWithArray:array];
			[self.activityView stopAnimating];
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCities) name:@"Province selected" object:nil];
}

#pragma mark UI Interaction

- (IBAction)provinceTouchDown:(UITextField *)textField {
	[ActionSheetStringPicker showPickerWithTitle:@"Select a province"
											rows:self.provinces
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.provinceTextField.text = [self.provinces objectAtIndex:selectedIndex];
										   [self loadCities];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];
}

- (IBAction)city1TouchDown:(UITextField *)textField {
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city1TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];

}

- (IBAction)city2TouchDown:(UITextField *)textField; {
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city2TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];
}

- (IBAction)city3TouchDown:(UITextField *)textField {
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city3TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];
}

- (IBAction)priceRangeTouchDown:(UITextField *)textField {
	NSArray *data = @[@"Plus or minus 25,000",
					  @"Plus or minus 50,000",
					  @"Plus or minus 100,000",
					  @"Plus or minus 250,000"];
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select the price range"
											rows:data
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.priceRangeTextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
	
	NSNumber *value = [NSNumber numberWithFloat:self.slider.value];
	NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
	
	self.priceLabel.text = modelNumberString;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark Data

- (void)loadCities {
	NSString *province = self.provinceTextField.text;
	
	[self.activityView startAnimating];
	
	[[Networking networking] citiesInProvince:province withCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.cities = [NSArray arrayWithArray:array];
			
			[self.activityView stopAnimating];
		}
	}];
}

@end
