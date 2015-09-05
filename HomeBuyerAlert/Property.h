//
//  Property.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *date;

@end
