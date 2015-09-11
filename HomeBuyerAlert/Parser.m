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
	NSMutableArray *toReturn = [NSMutableArray array];
	
	NSArray *provinces = [document childrenNamed:@"province"];
	
	for (SMXMLElement *province in provinces) {
		NSString *value = [province value];
		
		[toReturn addObject:value];
	}
	
	return toReturn.copy;
}

- (NSArray *)parseCities:(SMXMLDocument *)document {
	NSMutableArray *toReturn = [NSMutableArray array];
	
	NSArray *cities = [document childrenNamed:@"city"];
	
	for (SMXMLElement *city in cities) {
		NSString *value = [city value];
		
		[toReturn addObject:value];
	}
	
	return toReturn.copy;
}

- (NSArray *)parseProperties:(SMXMLDocument *)document {
	NSMutableArray *toReturn = [NSMutableArray array];
	
	SMXMLElement *root = [document childNamed:@"channel"];
	NSArray *items = [root childrenNamed:@"item"];
	
	for (SMXMLElement *item in items) {
		Property *current = [[Property alloc] init];
		
		NSString *photoURLRaw = [[item childNamed:@"description"] value];
		photoURLRaw = [[photoURLRaw componentsSeparatedByString:@"src='"] lastObject];
		photoURLRaw = [[photoURLRaw componentsSeparatedByString:@".JPG"] firstObject];
		NSString *photoURL = [photoURLRaw stringByAppendingString:@".JPG"];
		
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
	PropertyDetail *details = [[PropertyDetail alloc] init];
	
	
	
	return details;
}

@end
