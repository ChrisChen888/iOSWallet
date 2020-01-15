//
//  CCWSwitchAccountView.h
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
// 切换账号

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CCWSwitchAccountView;
@protocol CCWSwitchAccountViewDelegate <NSObject>

// 点击一行
- (void)CCW_SwitchAccountView:(CCWSwitchAccountView *)switchAccountView didSelectDBAccountModel:(CocosDBAccountModel *)dbAccountModel;
// 添加账号
- (void)CCW_SwitchViewAddAccountClick:(CCWSwitchAccountView *)switchAccountView;
@end

@interface CCWSwitchAccountView : UIView

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;
// YES 是否显示
@property (nonatomic,assign,getter=isShow) BOOL show;//是否显示

- (void)CCW_Show;

// 关闭
- (void)CCW_CloseCompletion:(void (^)(BOOL finished))completion;

@property (nonatomic ,weak) id<CCWSwitchAccountViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
