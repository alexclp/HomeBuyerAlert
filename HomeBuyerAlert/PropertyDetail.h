//
//  PropertyDetail.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyDetail : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *bathrooms;
@property (nonatomic, strong) NSString *garage;
@property (nonatomic, strong) NSString *bedrooms;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;

@end
