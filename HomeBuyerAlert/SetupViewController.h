//
//  SetupViewController.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *provinceTextField;
@property (nonatomic, weak) IBOutlet UITextField *city1TextField;
@property (nonatomic, weak) IBOutlet UITextField *city2TextField;
@property (nonatomic, weak) IBOutlet UITextField *city3TextField;

- (IBAction)provinceTouchDown:(UITextField *)textField;
- (IBAction)city1TouchDown:(UITextField *)textField;
- (IBAction)city2TouchDown:(UITextField *)textField;
- (IBAction)city3TouchDown:(UITextField *)textField;

@end
