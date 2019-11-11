//
//  CCWWalletHeaderView.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/13.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCWWalletHeaderView;
NS_ASSUME_NONNULL_BEGIN

@protocol CCWWalletHeaderDelegate <NSObject>
/**
 四个导航按钮点击
 @param button 按钮
 */
- (void)CCW_HomeNavbuttonClick:(CCWWalletHeaderView *)walletHeaderView button:(UIButton *)button;

/// 切换登录按钮点击
- (void)CCW_HomeClickToswitchAccount:(CCWWalletHeaderView *)walletHeaderView;

@end

@interface CCWWalletHeaderView : UIImageView

@property (nonatomic, weak) id<CCWWalletHeaderDelegate> delegate;

/** 总资产 */
@property (nonatomic, strong) NSNumber *assetsNum;

/** 账户名 */
@property (nonatomic, copy) NSString *account;
@end

NS_ASSUME_NONNULL_END
