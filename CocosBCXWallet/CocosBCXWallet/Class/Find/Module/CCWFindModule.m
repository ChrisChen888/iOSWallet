//
//  CCWFindModule
//  CocosBCXWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import "CCWFindModule.h"
#import "CCWFindViewController.h"
#import "CCWDappViewController.h"

@implementation CCWFindModule

- (UIViewController *)CCW_FindViewController
{
    CCWFindViewController *viewController = [[CCWFindViewController alloc] init];
    return viewController;
}

// 发现跳转到网页浏览
- (UIViewController *)CCW_FindWebViewControllerWithTitle:(NSString *)title loadDappURLString:(NSString *)url dappDec:(NSString *)dappDec dappIcon:(NSString *)dappIcon
{
    CCWDappViewController *dappVC = [[CCWDappViewController alloc] initWithTitle:title loadDappURLString:url dappDec:dappDec dappIcon:dappIcon];
    return dappVC;
}
@end

