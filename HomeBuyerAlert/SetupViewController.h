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

@property (nonatomic, weak) IBOutlet UITextField *priceRangeTextField;

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)provinceTouchDown:(UITextField *)textField;
- (IBAction)city1TouchDown:(UITextField *)textField;
- (IBAction)city2TouchDown:(UITextField *)textField;
- (IBAction)city3TouchDown:(UITextField *)textField;
- (IBAction)priceRangeTouchDown:(UITextField *)textField;
- (IBAction)sliderValueChanged:(UISlider *)slider;

- (IBAction)saveButtonPressed:(UIButton *)button;

@end
