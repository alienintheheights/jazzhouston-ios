//
//  FileUploadEngine.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/17/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "FileUploadEngine.h"

@implementation FileUploadEngine


-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params withPath:(NSString *)path {
	
	MKNetworkOperation *op = [self  operationWithPath:path
									params:params
									httpMethod:@"POST"
									ssl:NO];
	
	return op;
}
@end
