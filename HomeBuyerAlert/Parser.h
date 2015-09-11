//
//  Parser.h
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 03.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyDetail.h"

@class SMXMLDocument;

@interface Parser : NSObject

+ (Parser *)parser;

- (NSArray *)parseProvinces:(SMXMLDocument *)document;
- (NSArray *)parseCities:(SMXMLDocument *)document;
- (NSArray *)parseProperties:(SMXMLDocument *)document;
- (PropertyDetail *)parseDetails:(SMXMLDocument *)document;

@end
