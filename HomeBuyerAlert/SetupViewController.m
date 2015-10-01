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
#import "RKDropdownAlert.h"

#define IDIOM UI_USER_INTERFACE_IDIOM()
#define IPAD UIUserInterfaceIdiomPad

@interface SetupViewController ()

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *priceOver;

@property (nonatomic, assign) NSNumber *priceAboveIndex;

@end

@implementation SetupViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Settings";
	
	
	
	self.priceOver = @[@"Plus or minus 25,000",
					   @"Plus or minus 50,000",
					   @"Plus or minus 100,000",
					   @"Plus or minus 250,000"];
	
	// Check if settings already exist
	
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];
	
	self.slider.value = 450000;
	self.priceLabel.text = @"$450,000";
	
	self.priceRangeTextField.text = [self.priceOver objectAtIndex:0];
	
	if (settings) {
		self.provinceTextField.text = [settings objectForKey:@"province"];
		self.city1TextField.text = [settings objectForKey:@"city1"];
		
		if (![[settings objectForKey:@"city2"] isEqualToString:@""]) {
			self.city2TextField.text = [settings objectForKey:@"city2"];
		}
		
		if (![[settings objectForKey:@"city3"] isEqualToString:@""]) {
			self.city3TextField.text = [settings objectForKey:@"city3"];
		}
		
		self.slider.value = [[settings objectForKey:@"base"] doubleValue];
		
		NSNumber *value = [NSNumber numberWithFloat:self.slider.value];
		NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
		self.priceLabel.text = [@"$" stringByAppendingString:modelNumberString];
		
		self.priceRangeTextField.text = [self.priceOver objectAtIndex:[[settings objectForKey:@"priceabove"] intValue]];
		self.priceAboveIndex = [NSNumber numberWithInt:[[settings objectForKey:@"priceabove"] intValue]];
		
		[self loadCities];
		
	} else {
		// Load provinces
		
		[self loadProvinces];
	}
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCities) name:@"Province selected" object:nil];
}

#pragma mark UI Interaction

- (IBAction)provinceTouchDown:(UITextField *)textField {
	
	NSLog(@"TOUCH DOWN");
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select a province"
											rows:self.provinces
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.provinceTextField.text = [self.provinces objectAtIndex:selectedIndex];
										   [self loadCities];
										   
										   
										   self.city1TextField.text = @"";
										   self.city2TextField.text = @"";
										   self.city3TextField.text = @"";
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:textField];

}

- (IBAction)city1TouchDown:(UITextField *)textField {
	
	NSLog(@"TOUCH DOWN");
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city1TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:textField];

}

- (IBAction)city2TouchDown:(UITextField *)textField; {
	
	NSLog(@"TOUCH DOWN");
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city2TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:textField];
}

- (IBAction)city3TouchDown:(UITextField *)textField {
	
	NSLog(@"TOUCH DOWN");
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select a city"
											rows:self.cities
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.city3TextField.text = [self.cities objectAtIndex:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:textField];
}

- (IBAction)priceRangeTouchDown:(UITextField *)textField {
	
	NSLog(@"TOUCH DOWN");
	
	[ActionSheetStringPicker showPickerWithTitle:@"Select the price range"
											rows:self.priceOver
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.priceRangeTextField.text = [self.priceOver objectAtIndex:selectedIndex];
										   self.priceAboveIndex = [NSNumber numberWithInteger:selectedIndex];
										   
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:textField];
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
	
	NSNumber *value = [NSNumber numberWithFloat:self.slider.value];
	NSString *modelNumberString = [NSString localizedStringWithFormat:@"%@", value];
	
	self.priceLabel.text = [@"$" stringByAppendingString:modelNumberString];
}

- (IBAction)saveButtonPressed:(UIButton *)button {
	
	if ([self completedData]) {
		[self performSegueWithIdentifier:@"listSegue" sender:self];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"listSegue"]) {
		UITabBarController *tabbar = segue.destinationViewController;
		ListViewController *listVC = [tabbar.viewControllers objectAtIndex:0];
		
		NSDictionary *params = [self buildParams];
		[[NSUserDefaults standardUserDefaults] setObject:params forKey:@"prefs"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		listVC.requestParams = [NSDictionary dictionaryWithDictionary:params];
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
		
		NSNumber *basePrice = [NSNumber numberWithFloat:self.slider.value];
		
		int maxPrice;
		int minPrice;
		int base = basePrice.intValue;
		
//		int priceAboveIndex = 0;
		
		switch (self.priceAboveIndex.intValue) {
			case 0: {
				maxPrice = base + 25000;
				minPrice = base - 25000;
				
//				priceAboveIndex = 0;
				
				break;
			}
				
			case 1: {
				maxPrice = base + 50000;
				minPrice = base - 50000;
				
//				priceAboveIndex = 1;

				break;
			}
				
			case 2: {
				maxPrice = base + 100000;
				minPrice = base - 100000;
				
//				priceAboveIndex = 2;
				
				break;
			}
				
			case 3: {
				maxPrice = base + 250000;
				minPrice = base - 250000;
				
//				priceAboveIndex = 3;
				
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
				   @"maxprice": [NSString stringWithFormat:@"%d", maxPrice],
				   @"minprice": [NSString stringWithFormat:@"%d", minPrice],
				   @"base": [NSString stringWithFormat:@"%@", basePrice],
				   @"priceabove": [NSString stringWithFormat:@"%d", self.priceAboveIndex.intValue]};
	}
	
	return params;
}

- (void)loadCities {
	NSString *province = self.provinceTextField.text;
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefs"];
	
	[[Networking networking] citiesInProvince:province withCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.cities = [NSArray arrayWithArray:array];
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			
			if ([settings objectForKey:@"city1"]) {
				[self loadProvinces];
			}
		}
	}];
}

- (void)loadProvinces {
	
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[[Networking networking] activeProvincesWithCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.provinces = [NSArray arrayWithArray:array];
			[MBProgressHUD hideHUDForView:self.view animated:YES];
		}
	}];
}

@end
