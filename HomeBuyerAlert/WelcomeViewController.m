//
//  ViewController.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SetupViewController.h"
#import "GTMNSString+HTML.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"Welcome";
	
	// Do any additional setup after loading the view, typically from a nib.
	
	NSString *string = @"Scott Piercy &#038; James LeBlanc";
	NSString *newstring = [string stringByRemovingPercentEncoding];
	NSLog(@"new string: %@", [string gtm_stringByUnescapingFromHTML]);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"settingsSegue"]) {
		SetupViewController *vc = segue.destinationViewController;
		vc.isInitial = YES;
	}
}

@end
