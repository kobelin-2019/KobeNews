//
//  ImageViewColorHeaper.h
//  KobeNews
//
//  Created by kobelin on 2019/12/25.
//  Copyright © 2019 kobelin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface ImageViewColorHeaper : NSObject

+(void)blurEffect:(UIView *)view;
//判断颜色是不是亮色
+(BOOL) isLightColor:(UIColor*)clr;
//获取RGB值
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;
//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;

@end
