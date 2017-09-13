//
//  LayerImage.m
//  AutoLabel
//
//  Created by Mac on 2017/9/13.
//  Copyright © 2017年 LiYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerImage.h"
#import "UIImage+BHBEffects.h"

@implementation LayerImage
+ (UIImage *)imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *tintColor = [UIColor colorWithWhite:0.95 alpha:0.78];
    image = [image bhb_applyBlurWithRadius:15 tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
    UIGraphicsEndImageContext();
    
    return image;
}
@end
