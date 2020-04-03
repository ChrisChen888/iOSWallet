//
//  CCWDataBase+CCWFindDapp.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/4/3.
//  Copyright © 2020 邵银岭. All rights reserved.
//


#import "CCWDataBase.h"
#import "CCWDappModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCWDataBase (CCWFindDapp)
/* 创建我的Dapp表 */
- (void)CCW_CreateMyDappManageTable;

/* 存入收藏的Dapp */
- (void)CCW_SaveMyKeepDapp:(CCWDappModel *)myDapp;

/* 存入浏览过的Dapp */
- (void)CCW_SaveMyOpenedDapp:(CCWDappModel *)myDapp;

/** 查找我收藏的所有Dapp */
- (void)CCW_QueryMyKeepDappComplete:(void(^)(NSMutableArray<CCWDappModel *> * dappArray))complete;

/** 查找我浏览过的所有Dapp */
- (void)CCW_QueryMyOpenedDappComplete:(void(^)(NSMutableArray<CCWDappModel *> * dappArray))complete;

/** 查找我收藏的所有Dapp */
- (NSArray *)CCW_QueryMyKeepDappArray;

/** 查找我浏览过的所有Dapp */
- (NSArray *)CCW_QueryMyOpenedDappArray;

/* 删除数据库中我收藏的某个Dapp */
- (void)CCW_DeleteMyKeepDapp:(CCWDappModel *)dappModel;

/* 删除数据库中我浏览过的某个Dapp */
- (void)CCW_DeleteMyOpenedDapp:(CCWDappModel *)dappModel;
@end

NS_ASSUME_NONNULL_END
