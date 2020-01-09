//
//  CocosWalletApi.h
//  WalletInvoker
//
//  Created by 邵银岭 on 2020/1/7.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocosRequestObj.h"
#import "CocosResponseObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface CocosWalletApi : NSObject

/*!
 * @brief 向TP发起请求
 * @param obj 接收SDK内TPReqObj的业务子类, 如交易/转账TPTransferObj, ...
 * @return 成功发起请求会返回YES, 其他情况返回NO;
 */
+ (BOOL)sendObj:(CocosResponseObj *)obj;

/*!
 * @brief   处理TP的回调跳转
 * @discuss 在AppDelegate -(application:openURL:options:)方法里调用
 */
+ (BOOL)handleURL:(NSURL *)url
          options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;


@end

NS_ASSUME_NONNULL_END
