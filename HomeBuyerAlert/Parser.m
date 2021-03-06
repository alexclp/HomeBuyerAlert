//
//  Parser.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 03.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "Parser.h"
#import "SMXMLDocument.h"
#import "Property.h"

@implementation Parser

static Parser *parser;

+ (Parser *)parser {
	if (parser == nil) {
		parser = [[Parser alloc] init];
	}
	
	return parser;
}

- (NSArray *)parseProvinces:(SMXMLDocument *)document {
	NSLog(@"Parse provinces");
	NSMutableArray *toReturn = [NSMutableArray array];
	
	NSArray *provinces = [document childrenNamed:@"province"];
	
	for (SMXMLElement *province in provinces) {
		NSString *value = [province value];
		
		[toReturn addObject:value];
	}
	
	return toReturn.copy;
}

- (NSArray *)parseCities:(SMXMLDocument *)document {
	NSLog(@"Parse cities");
	NSMutableArray *toReturn = [NSMutableArray array];
	
	NSArray *cities = [document childrenNamed:@"city"];
	
	for (SMXMLElement *city in cities) {
		NSString *value = [city value];
		
		[toReturn addObject:value];
	}
	
	return toReturn.copy;
}

- (NSArray *)parseProperties:(SMXMLDocument *)document {
	NSLog(@"Parse properties");
	NSMutableArray *toReturn = [NSMutableArray array];
	
	SMXMLElement *root = [document childNamed:@"channel"];
	NSArray *items = [root childrenNamed:@"item"];
	
	for (SMXMLElement *item in items) {
		Property *current = [[Property alloc] init];
		
		NSString *photoURLRaw = [[item childNamed:@"description"] value];
		photoURLRaw = [[photoURLRaw componentsSeparatedByString:@"src='"] lastObject];
		
		NSString *photoURL = [NSString string];
		
		if ([photoURLRaw containsString:@".jpg"]) {
			photoURLRaw = [[photoURLRaw componentsSeparatedByString:@".jpg"] firstObject];
			photoURL = [photoURLRaw stringByAppendingString:@".jpg"];

		} else if ([photoURLRaw containsString:@".JPG"]) {
			photoURLRaw = [[photoURLRaw componentsSeparatedByString:@".JPG"] firstObject];
			photoURL = [photoURLRaw stringByAppendingString:@".JPG"];
		} else if ([photoURLRaw containsString:@".png"]) {
			photoURLRaw = [[photoURLRaw componentsSeparatedByString:@".png"] firstObject];
			photoURL = [photoURLRaw stringByAppendingString:@".png"];

		} else if ([photoURLRaw containsString:@".PNG"]) {
			photoURLRaw = [[photoURLRaw componentsSeparatedByString:@".PNG"] firstObject];
			photoURL = [photoURLRaw stringByAppendingString:@".PNG"];

		}
		
		current.title = [[item childNamed:@"title"] value];
		current.details = [[item childNamed:@"details"] value];
		current.price = [[item childNamed:@"price"] value];
		current.code = [[item childNamed:@"ref"] value];
		current.date = [[item childNamed:@"date"] value];
		current.imageURL = photoURL;
		current.latitude = [[item childNamed:@"latitude"] value];
		current.longitude = [[item childNamed:@"longitude"] value];
		
		[toReturn addObject:current];
	}
	
	return toReturn.copy;
}

- (PropertyDetail *)parseDetails:(SMXMLDocument *)document {
	NSLog(@"Parsing details");
	PropertyDetail *propertyDetails = [[PropertyDetail alloc] init];
		
	NSString *street = [[document childNamed:@"streetaddress"] value];
	NSString *city = [[document childNamed:@"city"] value];
	NSString *province = [[document childNamed:@"province"] value];
	
	propertyDetails.title = [NSString stringWithFormat:@"%@, %@, %@", street, city, province];
	propertyDetails.details = [[document childNamed:@"details"] value];
	
	propertyDetails.price = [[document childNamed:@"price"] value];
	propertyDetails.type = [[document childNamed:@"type"] value];
	propertyDetails.size = [[document childNamed:@"size"] value];
	propertyDetails.bathrooms = [[document childNamed:@"criteria1"] value];
	propertyDetails.garage = [[document childNamed:@"criteria3"] value];
	propertyDetails.bedrooms = [[document childNamed:@"criteria4"] value];
	
	SMXMLElement *element = [document childNamed:@"images"];

	NSArray *images = [element childrenNamed:@"image"];
	NSMutableArray *toAdd = [NSMutableArray array];
	for (SMXMLElement *image in images) {
		[toAdd addObject:[image value]];
	}
	
	propertyDetails.pics = toAdd.copy;
//	NSLog(@"Pics: %@", propertyDetails.pics);
	
	element = [document childNamed:@"user"];
	NSArray *userInfo = [element children];
	
//	NSLog(@"User info: %@", userInfo);
	
	propertyDetails.userName = [[userInfo objectAtIndex:0] value];
	propertyDetails.email = [[userInfo objectAtIndex:1] value];
	propertyDetails.phone = [[userInfo objectAtIndex:7] value];
	
	propertyDetails.privacy = [[userInfo objectAtIndex:userInfo.count - 1] value];
	propertyDetails.userType = [[userInfo objectAtIndex:5] value];
	propertyDetails.address = [[[userInfo objectAtIndex:2] value] stringByAppendingString:[NSString stringWithFormat:@" %@", [[userInfo objectAtIndex:3] value]]];
	propertyDetails.address = [propertyDetails.address stringByAppendingString:[NSString stringWithFormat:@" %@", [[userInfo objectAtIndex:4] value]]];
	propertyDetails.company = [[userInfo objectAtIndex:6] value];
	
	return propertyDetails;
}

@end
