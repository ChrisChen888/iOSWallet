//
//  CocosSwitchAccountView.h
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
// 切换账号

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CocosSwitchAccountView;
@protocol CocosSwitchAccountViewDelegate <NSObject>

// 点击一行
- (void)Cocos_SwitchAccountView:(CocosSwitchAccountView *)switchAccountView didSelectDBAccountModel:(CocosDBAccountModel *)dbAccountModel;
// 添加账号
//- (void)CCW_SwitchViewAddAccountClick:(CocosSwitchAccountView *)switchAccountView;
@end

@interface CocosSwitchAccountView : UIView

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;
// YES 是否显示
@property (nonatomic,assign,getter=isShow) BOOL show;//是否显示

- (void)Cocos_Show;

// 关闭
- (void)Cocos_CloseCompletion:(void (^)(BOOL finished))completion;

@property (nonatomic ,weak) id<CocosSwitchAccountViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
