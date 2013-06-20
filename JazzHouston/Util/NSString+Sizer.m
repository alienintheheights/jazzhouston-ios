//
//  NSString+Sizer.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/19/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "NSString+Sizer.h"

@implementation NSString (Sizer)

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of the label
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat maxHeight = 9999;
    CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
	
    return expectedLabelSize.height;
}

- (UILabel *)sizeCellLabelWithSystemFontOfSize:(CGFloat)size {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat height = [self textHeightForSystemFontOfSize:size] + 10.0;
    CGRect frame = CGRectMake(10.0f, 10.0f, width, height);
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.backgroundColor = [UIColor clearColor];
    cellLabel.textAlignment = NSTextAlignmentCenter;
    cellLabel.font = [UIFont systemFontOfSize:size];
	
    cellLabel.text = self;
    cellLabel.numberOfLines = 0;
    [cellLabel sizeToFit];
    return cellLabel;
}

@end