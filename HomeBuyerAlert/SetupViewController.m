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
#import "MBProgressHUD.h"
#import "ListViewController.h"

@interface SetupViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;

@property (nonatomic, assign) NSNumber *priceAboveIndex;

@end

@implementation SetupViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"Setup Controller");
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] activeProvincesWithCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.provinces = [NSArray arrayWithArray:array];
			[MBProgressHUD hideHUDForView:self.view animated:YES];
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
										   self.priceRangeTextField.text = [data objectAtIndex:selectedIndex];
										   self.priceAboveIndex = [NSNumber numberWithInteger:selectedIndex];
										   
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

- (IBAction)saveButtonPressed:(UIButton *)button {
	
	if ([self completedData]) {
		NSLog(@"Hello");
		[self performSegueWithIdentifier:@"listSegue" sender:self];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"listSegue"]) {
		UITabBarController *tabbar = segue.destinationViewController;
		ListViewController *listVC = [tabbar.viewControllers objectAtIndex:0];
		
		listVC.requestParams = [NSDictionary dictionaryWithDictionary:[self buildParams]];
	}
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

#pragma mark Data

- (BOOL)completedData {
	if ([self.provinceTextField.text isEqualToString:@""] ||
		[self.city1TextField.text isEqualToString:@""] ||
		[self.priceLabel.text isEqualToString:@""] ||
		[self.priceRangeTextField.text isEqualToString:@""]) {
		return NO;
	}
	
	return YES;
}

- (NSDictionary *)buildParams {
	NSDictionary *params = [NSDictionary dictionary];
	
	if (![self completedData]) {
		
		UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please complete all mandatory fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[error show];
		
		return nil;
	} else {
		NSString *province = self.provinceTextField.text;
		NSString *city1 = self.city1TextField.text;
		
		NSString *city2 = @"";
		NSString *city3 = @"";
		
		if (![self.city2TextField.text isEqualToString:@""]) {
			city2 = self.city2TextField.text;
		}
		
		if (![self.city3TextField.text isEqualToString:@""]) {
			city3 = self.city3TextField.text;
		}
		
		NSString *basePrice = self.priceLabel.text;
		
		int maxPrice;
		int minPrice;
		int base = basePrice.intValue;
		
		switch (self.priceAboveIndex.intValue) {
			case 0: {
				maxPrice = base + 25000;
				minPrice = base - 25000;
				
				break;
			}
				
			case 1: {
				maxPrice = base + 50000;
				minPrice = base - 50000;

				break;
			}
				
			case 2: {
				maxPrice = base + 100000;
				minPrice = base - 100000;
				
				break;
			}
				
			case 3: {
				maxPrice = base + 250000;
				minPrice = base - 250000;
				
				break;
			}
				
			default: {
				break;
			}
		}
		
		params = @{@"province": province,
				   @"city1":	city1,
				   @"city2":	city2,
				   @"city3":	city3,
				   @"maxprice": [NSNumber numberWithInt:maxPrice],
				   @"minprice": [NSNumber numberWithInt:minPrice]};
	}
	
	return params;
}

- (void)loadCities {
	NSString *province = self.provinceTextField.text;
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] citiesInProvince:province withCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.cities = [NSArray arrayWithArray:array];
			[MBProgressHUD hideHUDForView:self.view animated:YES];
		}
	}];
}

@end
