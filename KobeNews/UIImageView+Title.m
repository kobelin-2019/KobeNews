//
//  UIImageView+UImageView_Title.m
//  KobeNews
//
//  Created by kobelin on 2019/12/25.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "UIImageView+Title.h"
#import "ImageViewColorHeaper.h"


@implementation UIImageView (Title)

- (void)addTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    CGRect rec = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height*0.2);
    titleLabel.frame = rec;
    titleLabel.text = title;
    UIImageView *blurView = [[UIImageView alloc] initWithFrame:rec];
    [ImageViewColorHeaper blurEffect:blurView];
    [self addSubview:blurView];
    if ([ImageViewColorHeaper isLightColor:[UIColor colorWithPatternImage:[ImageViewColorHeaper imageFromView:self atFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]]]) {
        titleLabel.textColor = [UIColor blackColor];
    }else{
        titleLabel.textColor = [UIColor whiteColor];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [blurView addSubview:titleLabel];
}

@end
