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
#import "ASIFormDataRequest.h"
#import "Parser.h"

#define ProvinceURL @"http://homebuyeralert.ca/province.php"
#define CitiesURL @"http://homebuyeralert.ca/cities.php"
#define ResultsURL @"http://homebuyeralert.ca/property-custom-new.php"
#define DetailsURL @"http://homebuyeralert.ca/listing-xml.php"

@implementation Networking

static Networking *networking;

+ (Networking *)networking {
	if (networking == nil) {
		networking = [[Networking alloc] init];
	}
	
	return networking;
}

- (void)activeProvincesWithCompletion:(void(^)(NSArray *array, NSError *error))completion
 {
	NSLog(@"Active provinces");
	
	NSURL *url = [NSURL URLWithString:@"http://homebuyeralert.ca/province.php"];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setCompletionBlock:^{
		// Use when fetching binary data
		NSData *responseData = [request responseData];
		
		NSArray *parsed = [[Parser parser] parseProvinces:[SMXMLDocument documentWithData:responseData error:nil]];
		
		completion(parsed, nil);
	}];
	[request setFailedBlock:^{
		NSError *error = [request error];
		
		completion(nil, error);
	}];
	[request startAsynchronous];
}

- (void)citiesInProvince:(NSString *)province withCompletion:(void(^)(NSArray *array, NSError *error))completion {
	NSLog(@"Cities in province");
	
	NSString *urlString = [CitiesURL stringByAppendingString:[NSString stringWithFormat:@"?province=%@", province]];
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString:urlString];
	

	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
	
	[request setCompletionBlock:^{
		NSData *responseData = [request responseData];
		SMXMLDocument *document = [SMXMLDocument documentWithData:responseData error:nil];
		NSArray *parsed = [[Parser parser] parseCities:document];
		completion(parsed, nil);
	}];
	
	[request setFailedBlock:^{
		NSError *error = [request error];
		completion(nil, error);
	}];
	
	[request startAsynchronous];
}

- (void)properties:(NSDictionary *)params withCompletion:(void(^)(NSArray *array, NSError *))completion {
	
	

}

@end
