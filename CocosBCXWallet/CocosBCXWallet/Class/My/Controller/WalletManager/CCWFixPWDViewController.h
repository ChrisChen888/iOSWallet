//
//  CCWFixPWDViewController.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/19.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWFixPWDViewController : UIViewController

@property (nonatomic, copy) void (^setpwdSuccess)(void);

@property (nonatomic, assign) CocosWalletMode walletMode;

@end

NS_ASSUME_NONNULL_END
