//
//  CCWConstkey.h
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - App检查更新
UIKIT_EXTERN BOOL CCWIsHaveUpdate;//!< 是否有更新
UIKIT_EXTERN BOOL CCWIsForceUpdate;//!< 是否需要强制更新
UIKIT_EXTERN NSString * CCWAppNewVersion;//!< 新的App版本号
UIKIT_EXTERN NSString * CCWNewAppDownloadurl;//!< 新App的下载链接
UIKIT_EXTERN NSString * CCWNewAppUpdateNotes;//!< 新App的更新内容
UIKIT_EXTERN NSString * CCWNewAppUpdateEnNotes;//!< 新App的更新内容,英文

#pragma mark - 节点类型
UIKIT_EXTERN BOOL CCWNetNotesType;//!< 节点类型，测试网，主网

#pragma mark - 汇率
UIKIT_EXTERN NSString * const CCWCurrencyType;//!< 当前显示CNY或者USD(YES是CNY,NO是USD)
UIKIT_EXTERN NSString * const CCWCurrencyValueKey;//!< 缓存汇率的值

UIKIT_EXTERN NSString * const CCWCurrencyCocosPrice;//!< 缓存COCOS价格

#pragma mark - 第三方Key
UIKIT_EXTERN NSString * const UMengAppKey;// 友盟AppKey
