//
//  Networking.m
//  HomeBuyerAlert
//
//  Created by Alexandru Clapa on 01.09.2015.
//  Copyright (c) 2015 Alexandru Clapa. All rights reserved.
//

#import "Networking.h"
#import "AFNetworking.h"
#import "SMXMLDocument.h"
#import "ASIHTTPRequest.h"

@implementation Networking

static Networking *networking;

+ (Networking *)networking {
	if (networking == nil) {
		networking = [[Networking alloc] init];
	}
	
	return networking;
}

- (NSArray *)parseProvinces:(SMXMLDocument *)document {
	NSMutableArray *toReturn = [NSMutableArray array];
	
	NSArray *provinces = [document childrenNamed:@"province"];
	
	NSLog(@"Element = %@", [provinces[0] class]);
	
	for (SMXMLElement *province in provinces) {
		NSString *value = [province value];
		
		[toReturn addObject:value];
	}
	
	return toReturn.copy;
}

- (void)activeProvincesWithCompletion:(void(^)(NSArray *array, NSError *error))completion
 {
	NSLog(@"Active provinces");
	
	 NSURL *url = [NSURL URLWithString:@"http://homebuyeralert.ca/province.php"];
	 __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	 [request setCompletionBlock:^{
		 // Use when fetching binary data
		 NSData *responseData = [request responseData];
		 
		 NSArray *parsed = [self parseProvinces:[SMXMLDocument documentWithData:responseData error:nil]];
		 
		 completion(parsed, nil);
	 }];
	 [request setFailedBlock:^{
		 NSError *error = [request error];
		 
		 completion(nil, error);
	 }];
	 [request startAsynchronous];
}

- (NSArray *)citiesInProvince:(NSString *)province {
	
	
	return nil;
}

- (NSArray *)propertiesInProvince:(NSString *)province city1:(NSString *)city1 city2:(NSString *)city2 city3:(NSString *)city3 minPrice:(NSString *)min maxPrice:(NSString *)max {
	
	
	return nil;
}

#pragma mark NSXMLParser Delegate Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
}

@end
