//
//  PropertyAnnotation.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 08.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "PropertyAnnotation.h"

@implementation PropertyAnnotation

- (id)initwithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t {
	self.coordinate = coord;
	self.title = t;
	
	return self;
}

@end
