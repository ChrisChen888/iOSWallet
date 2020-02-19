//
//  CCWDappViewController.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/27.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWDappViewController : UIViewController
// 带有Dapp链接的
- (instancetype)initWithTitle:(NSString *)dappTitle loadDappURLString:(NSString *)dappURLString dappDec:(NSString *)dappDec dappIcon:(NSString *)dappDec;
@end

NS_ASSUME_NONNULL_END
