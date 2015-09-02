//
//  Networking.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject <NSXMLParserDelegate>

+ (Networking *)networking;

- (void)activeProvincesWithCompletion:(void(^)(NSArray *array, NSError *error))completion
;
- (NSArray *)citiesInProvince:(NSString *)province;
- (NSArray *)propertiesInProvince:(NSString *)province city1:(NSString *)city1 city2:(NSString *)city2 city3:(NSString *)city3 minPrice:(NSString *)min maxPrice:(NSString *)max;


@end
