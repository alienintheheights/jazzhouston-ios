//
//  NSString+Sizer.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/19/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Sizer)
- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size;
- (UILabel *)sizeCellLabelWithSystemFontOfSize:(CGFloat)size;
@end