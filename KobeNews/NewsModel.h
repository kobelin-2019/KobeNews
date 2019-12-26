//
//  NewsModel.h
//  KobeNews
//
//  Created by kobelin on 2019/12/25.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

@property NSString *newsImage;
@property NSString *newsTitle;
@property NSString *newsUrl;

- (instancetype)initWithImage:(UIImage *) newsTitle:(NSString *)title newsUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
