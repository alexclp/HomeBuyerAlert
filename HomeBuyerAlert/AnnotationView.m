//
//  AnnotationView.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 09.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)showDetails:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.propertyID forKey:@"PropertyID"];
	[defaults synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Annotation Tapped" object:nil];
}

@end
