//
//  Networking.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject

+ (Networking *)networking;

- (void)activeProvincesWithCompletion:(void(^)(NSArray *array, NSError *error))completion
;
- (void)citiesInProvince:(NSString *)province withCompletion:(void(^)(NSArray *array, NSError *error))completion;
- (void)properties:(NSDictionary *)params withCompletion:(void(^)(NSArray *array, NSError *))completion;


@end
