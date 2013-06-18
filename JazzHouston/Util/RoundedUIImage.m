//
//  RoundedUIImage.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/10/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "RoundedUIImage.h"

@implementation RoundedUIImage

+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
	
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
	
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
								cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
	
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
	
    return imageView.image;
}

@end
