//
//  CCWDataBase.m
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import "CCWDataBase.h"
#import "CCWDataBase+CCWNodeINfo.h"
#import "CCWDataBase+CCWFindDapp.h"

@implementation CCWDataBase

static CCWDataBase *ccwDataBase = nil;

+ (instancetype)CCW_shareDatabase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ccwDataBase = [[CCWDataBase alloc] init];
    });
    return ccwDataBase;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
        // 联系人
        [self CCW_CreateContactTable];
        
        // 节点表
        [self CCW_CreateNodeInfoTable];
        
        // Dapp
        [self CCW_CreateMyDappManageTable];
    }
    return self;
}

- (NSString *)dbPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"CocosWallet.sqlite"];
    CCWLog(@"数据库路径:%@",dbPath);
    return dbPath;
}

/**
 判断一张表是否已经存在
 @param tablename 表名
 */
- (BOOL)CCW_isExistTable:(NSString *)tablename
{
    __block BOOL result = NO;
    [_dataBaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tablename];
        while ([rs next]){
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
                result = NO;
            }else{
                result = YES;
            }
        }
    }];
    return result;
}

@end
