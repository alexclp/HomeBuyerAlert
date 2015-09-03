//
//  Parser.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 03.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "Parser.h"

@implementation Parser

static Parser *parser;

+ (Parser *)parser {
	if (parser == nil) {
		parser = [[Parser alloc] init];
	}
	
	return parser;
}


@end
