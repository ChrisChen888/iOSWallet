//
//  UIImageView+CCWImageView.m
//  CocosWallet
//
//  Created by SYL on 2018/11/16.
//  Copyright © 2018 CCW. All rights reserved.
//

#import "UIImageView+CCWImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (CCWImageView)

- (void)CCW_SetImageWithURL:(NSString *)urlString
{
    
    [self sd_setImageWithURL:URLFromString(urlString) placeholderImage:[UIImage imageNamed:@"cocosIcon"] options:0 progress:nil completed:nil];
    
    //    [self sd_setImageWithURL:URLFromString(urlString) placeholderImage:[UIImage imageNamed:@"ccwplaceholder"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //        if (error) {
    //            return;
    //        }else {
    //            self.image = image;
    //        }
    //    }];
}
@end
