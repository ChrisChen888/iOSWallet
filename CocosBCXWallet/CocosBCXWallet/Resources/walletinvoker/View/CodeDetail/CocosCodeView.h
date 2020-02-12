//
//  CocosCodeView.h
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
// 展示代码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocosCodeView : UIView

/** 数据源 */
@property (nonatomic, copy) NSString *codeString;
// YES 是否显示
@property (nonatomic,assign,getter=isShow) BOOL show;//是否显示

- (void)Cocos_Show;

// 关闭
- (void)Cocos_CloseCompletion:(void (^)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
