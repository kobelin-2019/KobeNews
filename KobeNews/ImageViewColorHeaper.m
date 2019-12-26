//
//  ImageViewColorHeaper.m
//  KobeNews
//
//  Created by kobelin on 2019/12/25.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "ImageViewColorHeaper.h"
#import "UIKit/UIKit.h"
@implementation ImageViewColorHeaper

//设置毛玻璃效果
+(void)blurEffect:(UIView *)view{

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectVIew = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectVIew.frame = view.bounds;
    [view addSubview:effectVIew];

}

//判断颜色是不是亮色
+(BOOL) isLightColor:(UIColor*)clr {
    float c1,c2,c3;
    c1 = c2 = c3 = 0.0;
    return [ImageViewColorHeaper getRGBComponents:c1 green:c2 blue:c3 forColor:clr];
//        NSLog(@"%f %f %f", components[0], components[1], components[2]);
    
}



//获取RGB值
+ (BOOL)getRGBComponents:(float)c1 green:(float)c2 blue:(float)c3 forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    c1 = resultingPixel[0];
    c2 = resultingPixel[1];
    c3 = resultingPixel[2];
    return ((c1+c2+c3<382.0) ? NO :YES);
}

//获得某个范围内的屏幕图像
+ (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
@end
