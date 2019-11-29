//
//  CCWTransRecordModel.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/20.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransRecordModel.h"

@implementation CCWContractInfo : NSObject

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}
@end

@implementation CCWAmountFee


@end

@implementation CCWMemo


@end

@implementation CCWOperation

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"fee": [CCWAmountFee class],
             @"amount": [CCWAmountFee class],
//             @"memo": [CCWMemo class]
             };
}


@end

@implementation CCWTransRecordModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"operation": [CCWOperation class],
             };
}

- (NSString *)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 获得日期对象
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:timeZone];
    
    NSDate *createDate = [formatter dateFromString:_timestamp];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 东八区
    //    NSTimeZone* timeZone8 = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    // 获取系统时区
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
//    // 获取本地时区
//    NSTimeZone *zone2 = [NSTimeZone localTimeZone];
//    // 获取默认时区
//    NSTimeZone *zone3 = [NSTimeZone defaultTimeZone];
    
    [formatter setTimeZone:zone1];
//    [formatter setTimeZone:timeZone8];
    return [formatter stringFromDate:createDate];
}

@end
