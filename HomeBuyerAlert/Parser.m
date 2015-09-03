//
//  Parser.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 03.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "Parser.h"
#import "SMXMLDocument.h"

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

@end
