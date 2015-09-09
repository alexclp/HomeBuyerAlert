//
//  PropertyAnnotation.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 08.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PropertyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

- (id)initwithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)t;

@end
