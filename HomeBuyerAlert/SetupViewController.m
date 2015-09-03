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

@end

@implementation SetupViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"Setup Controller");
	
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityView startAnimating];
	
	[[Networking networking] activeProvincesWithCompletion:^(NSArray *array, NSError *error) {
		if (error) {
			
		} else {
			self.provinces = [NSArray arrayWithArray:array];
			[activityView stopAnimating];
		}
	}];
}

- (IBAction)provinceTouchDown:(UITextField *)textField {
	[ActionSheetStringPicker showPickerWithTitle:@"Select a province"
											rows:self.provinces
								initialSelection:0
									   doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
										   self.provinceTextField.text = [self.provinces objectAtIndex:selectedIndex];
									   }
									 cancelBlock:^(ActionSheetStringPicker *picker) {
										 NSLog(@"Block Picker Canceled");
									 }
										  origin:self.view];
}

- (IBAction)city1TouchDown:(UITextField *)textField {
	
}

- (IBAction)city2TouchDown:(UITextField *)textField; {
	
}

- (IBAction)city3TouchDown:(UITextField *)textField {
	
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}

@end
