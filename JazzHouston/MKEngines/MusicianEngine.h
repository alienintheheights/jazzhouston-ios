//
//  MusicianEngine.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface MusicianEngine : MKNetworkEngine

typedef void (^MusiciansResponseBlock)(NSMutableArray* jsonResponse);

-(void) fetchInstruments:(MusiciansResponseBlock)instrumentCellBlock
			errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchRemoteMusicians:(int)instId
			   forPageNumber:(int)pageNumber
			 withForceReload:(BOOL)forceReload
		   completionHandler:(MusiciansResponseBlock)musicianCellBlock
				errorHandler:(MKNKErrorBlock)errorBlock;
@end
