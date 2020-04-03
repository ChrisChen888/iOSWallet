//
//  CCWDataBase+CCWFindDapp.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/4/3.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWDataBase+CCWFindDapp.h"

@implementation CCWDataBase (CCWFindDapp)
/* 创建我的Dapp表 */
- (void)CCW_CreateMyDappManageTable;
{
    // 创表(字段：Dapp 链接作为主键、 名字、图片地址、 是否是收藏、类型)
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_mymangedapp (dappUrl text PRIMARY KEY,dappTitle text,dappEnTitle text,dappPicUrl text,dappDesc text,dappEnDesc text,isKeep bit);"];
    }];
}

/* 存入收藏的Dapp */
- (void)CCW_SaveMyKeepDapp:(CCWDappModel *)myDapp;
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT OR REPLACE INTO t_mymangedapp(dappUrl, dappTitle, dappPicUrl, dappDesc, isKeep, dappEnTitle, dappEnDesc) VALUES (? ,? ,? ,? ,? ,? ,?);",myDapp.linkUrl ,myDapp.title ,myDapp.logo ,myDapp.dec ,@1,myDapp.enTitle,myDapp.enDec];
    }];
}

/* 存入浏览过的Dapp */
- (void)CCW_SaveMyOpenedDapp:(CCWDappModel *)myDapp;
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT OR REPLACE INTO t_mymangedapp(dappUrl, dappTitle, dappPicUrl, dappDesc, isKeep, dappEnTitle, dappEnDesc) VALUES (? ,? ,? ,? ,? ,? ,?);",myDapp.linkUrl ,myDapp.title ,myDapp.logo ,myDapp.dec ,@0,@"",@""];
    }];
}

/** 查找我收藏的所有Dapp */
- (void)CCW_QueryMyKeepDappComplete:(void(^)(NSMutableArray<CCWDappModel *> * dappArray))complete;
{
    // 执行SQL
    NSMutableArray *myKeepDappArray = [NSMutableArray array];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 根据请求参数生成对应的查询SQL语句
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT * FROM t_mymangedapp where isKeep = 1;"];
        while (resultSet.next) {
            CCWDappModel *dappModel = [[CCWDappModel alloc] init];
            dappModel.linkUrl = [resultSet stringForColumn:@"dappUrl"];
            dappModel.title = [resultSet stringForColumn:@"dappTitle"];
            dappModel.logo = [resultSet stringForColumn:@"dappPicUrl"];
            dappModel.dec = [resultSet stringForColumn:@"dappDesc"];
            dappModel.enDec = [resultSet stringForColumn:@"dappEnDesc"];
            dappModel.enTitle = [resultSet stringForColumn:@"dappEnTitle"];
            [myKeepDappArray addObject:dappModel];
        }
        [resultSet close];
    }];
    !complete ?: complete(myKeepDappArray);
}

/** 查找我浏览过的所有Dapp */
- (void)CCW_QueryMyOpenedDappComplete:(void(^)(NSMutableArray<CCWDappModel *> * dappArray))complete;
{
    // 执行SQL
    NSMutableArray *myOpenedDappArray = [NSMutableArray array];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 根据请求参数生成对应的查询SQL语句
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT * FROM t_mymangedapp where isKeep = 0;"];
        while (resultSet.next) {
            CCWDappModel *dappModel = [[CCWDappModel alloc] init];
            dappModel.linkUrl = [resultSet stringForColumn:@"dappUrl"];
            dappModel.title = [resultSet stringForColumn:@"dappTitle"];
            dappModel.logo = [resultSet stringForColumn:@"dappPicUrl"];
            dappModel.dec = [resultSet stringForColumn:@"dappDesc"];
            dappModel.enDec = [resultSet stringForColumn:@"dappEnDesc"];
            dappModel.enTitle = [resultSet stringForColumn:@"dappEnTitle"];
            [myOpenedDappArray addObject:dappModel];
        }
        [resultSet close];
    }];
    !complete ?: complete(myOpenedDappArray);

}

/** 查找我收藏的所有Dapp */
- (NSArray *)CCW_QueryMyKeepDappArray;
{
    // 执行SQL
    NSMutableArray *myKeepDappArray = [NSMutableArray array];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 根据请求参数生成对应的查询SQL语句
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT * FROM t_mymangedapp where isKeep = 1;"];
        while (resultSet.next) {
            CCWDappModel *dappModel = [[CCWDappModel alloc] init];
            dappModel.linkUrl = [resultSet stringForColumn:@"dappUrl"];
            dappModel.title = [resultSet stringForColumn:@"dappTitle"];
            dappModel.logo = [resultSet stringForColumn:@"dappPicUrl"];
            dappModel.dec = [resultSet stringForColumn:@"dappDesc"];
            dappModel.enDec = [resultSet stringForColumn:@"dappEnDesc"];
            dappModel.enTitle = [resultSet stringForColumn:@"dappEnTitle"];
            [myKeepDappArray addObject:dappModel];
        }
        [resultSet close];
    }];
    return [[myKeepDappArray reverseObjectEnumerator] allObjects];
//    return myKeepDappArray;
}

/** 查找我浏览过的所有Dapp */
- (NSArray *)CCW_QueryMyOpenedDappArray;
{
    // 执行SQL
    NSMutableArray *myOpenedDappArray = [NSMutableArray array];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        // 根据请求参数生成对应的查询SQL语句
        FMResultSet *resultSet = [db executeQueryWithFormat:@"SELECT * FROM t_mymangedapp where isKeep = 0;"];
        while (resultSet.next) {
            CCWDappModel *dappModel = [[CCWDappModel alloc] init];
            dappModel.linkUrl = [resultSet stringForColumn:@"dappUrl"];
            dappModel.title = [resultSet stringForColumn:@"dappTitle"];
            dappModel.logo = [resultSet stringForColumn:@"dappPicUrl"];
            dappModel.dec = [resultSet stringForColumn:@"dappDesc"];
            dappModel.enDec = [resultSet stringForColumn:@"dappEnDesc"];
            dappModel.enTitle = [resultSet stringForColumn:@"dappEnTitle"];
            [myOpenedDappArray addObject:dappModel];
        }
        [resultSet close];
    }];
    return [[myOpenedDappArray reverseObjectEnumerator] allObjects];
//    return myOpenedDappArray;
}

/* 删除数据库中我收藏的某个Dapp */
- (void)CCW_DeleteMyKeepDapp:(CCWDappModel *)dappModel;
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"DELETE FROM t_mymangedapp WHERE dappUrl = %@ and isKeep = 1;",dappModel.linkUrl];
    }];
}

/* 删除数据库中我浏览过的某个Dapp */
- (void)CCW_DeleteMyOpenedDapp:(CCWDappModel *)dappModel;
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"DELETE FROM t_mymangedapp WHERE dappUrl = %@ and isKeep = 0;",dappModel.linkUrl];
    }];
}

@end
