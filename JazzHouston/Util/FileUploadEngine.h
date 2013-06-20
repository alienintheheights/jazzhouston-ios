//
//  FileUploadEngine.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/17/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface FileUploadEngine : MKNetworkEngine

-(MKNetworkOperation *)postDataToServer:(NSMutableDictionary *)params withPath:(NSString *)path;
@end
