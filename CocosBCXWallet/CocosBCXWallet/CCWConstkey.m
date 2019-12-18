//
//  CCWConstkey.m
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import "CCWConstkey.h"

#pragma mark - App检查更新
BOOL CCWIsHaveUpdate;//!< 是否有更新
BOOL CCWIsForceUpdate;//!< 是否需要强制更新
NSString * CCWAppNewVersion;//!< 新的App版本号
NSString * CCWNewAppDownloadurl;//!< 新App的下载链接
NSString * CCWNewAppUpdateNotes;//!< 新App的更新内容
NSString * CCWNewAppUpdateEnNotes;//!< 新App的更新内容,英文

#pragma mark - 节点类型
BOOL CCWNetNotesType;//!< 节点类型，测试网，主网

#pragma mark - 汇率
NSString * const CCWCurrencyType = @"CCWCurrencyType";//(YES是USD,NO是CNY)
NSString * const CCWCurrencyValueKey = @"CCWCurrencyValueKey";//!< 缓存汇率的值

NSString * const CCWCurrencyCocosPrice = @"CCWCurrencyCocosPrice";//!< 缓存COCOS价格

#pragma mark - 第三方Key
NSString * const UMengAppKey = @"5d006f774ca35713eb0007d0";// 友盟AppKey

