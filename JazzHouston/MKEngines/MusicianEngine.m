//
//  MusicianEngine.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MusicianEngine.h"

@implementation MusicianEngine

#define LIST_INSTRUMENTS @"/musicians/list_instruments"
#define JH_MUSICIANS_BY_INST_URL(__INSTID__, __PAGENUM__)  [NSString stringWithFormat:@"/musicians/byinst/%d.json?page=%d", __INSTID__, __PAGENUM__]

-(void) fetchInstruments:(MusiciansResponseBlock)instrumentCellBlock
				errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:LIST_INSTRUMENTS
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			instrumentCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op];
	
}


-(void) fetchRemoteMusicians:(int)instId
			forPageNumber:(int)pageNumber
		  withForceReload:(BOOL)forceReload
		completionHandler:(MusiciansResponseBlock)musicianCellBlock
			 errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_MUSICIANS_BY_INST_URL(instId, pageNumber)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			musicianCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op forceReload:forceReload];
	
}

@end
