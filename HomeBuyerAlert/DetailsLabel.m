//
//  DetailsLabel.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 17.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "DetailsLabel.h"

@implementation DetailsLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	
	// If this is a multiline label, need to make sure
	// preferredMaxLayoutWidth always matches the frame width
	// (i.e. orientation change can mess this up)
	
	if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
		self.preferredMaxLayoutWidth = self.bounds.size.width;
		[self setNeedsUpdateConstraints];
	}
}

@end
