//
//  RoundedUIImage.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/10/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedUIImage : UIImage

+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;

@end
