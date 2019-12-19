//
//  TWDecimalTool.m
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import "CCWDecimalTool.h"

@implementation CCWDecimalTool
/** string类型转NSDecimalNumber */
+(NSDecimalNumber *)CCW_decimalNumberWithString:(NSString *)stringValue
{
    if (stringValue.length == 0 || !stringValue || !VALIDATE_STRING(stringValue) || IsStrEmpty(stringValue) || IsNilOrNull(stringValue) || [stringValue isEqualToString:@"(null)"]) {
        stringValue = @"0";
    }
    NSDecimalNumber *dnTemp = [NSDecimalNumber decimalNumberWithString:stringValue?:@"0"];
    return dnTemp;
}

/**
 计算两数积 = 乘数 * 被乘数
 
 @param multiplier 乘数
 @param faciend 被乘数
 */
+(NSDecimalNumber *)CCW_multiplyTotalAssetsWithMultiplier:(NSString *)multiplier faciend:(NSString *)faciend
{
    NSDecimalNumber *multiplierDecimalNumber = [self CCW_decimalNumberWithString:multiplier];
    NSDecimalNumber *faciendDecimalNumber = [self CCW_decimalNumberWithString:faciend];
    NSDecimalNumber *totalDecimalNumber =  [multiplierDecimalNumber decimalNumberByMultiplyingBy:faciendDecimalNumber];
    return totalDecimalNumber;
}

/**
 汇率转换(向下取正)
 
 @param price 需要转换的总值
 @param scale 小数点
 */
+(NSString *)CCW_convertRateWithPrice:(NSString *)price scale:(NSInteger)scale
{
    // 汇率转换
    NSDecimalNumber *dnValue = [self CCW_convertRateWithValue:price];
    // 保留小数位
    NSDecimalNumber *result = [self CCW_decimalSubScale:dnValue scale:scale];
    return result.stringValue;
}

#pragma mark - Private
/**
 汇率转换
 
 @param value 需要转换的总值
 */
+(NSDecimalNumber *)CCW_convertRateWithValue:(NSString *)value
{
    NSDecimalNumber *dnValue = nil;
    if (!CCWCNYORUSD) { // USD
        dnValue = [self CCW_decimalNumberWithString:value];
    }else{// CNY
        // 需要转换的总值
        dnValue = [self CCW_decimalNumberWithString:value];
        // 取出缓存的汇率
        NSString *exchangerate = [CCWSaveTool objectForKey:CCWCurrencyValueKey];
        NSDecimalNumber *currencyExchangerate = [self CCW_decimalNumberWithString:exchangerate];
        dnValue = [dnValue decimalNumberByMultiplyingBy:currencyExchangerate];
    }
    return dnValue;
}

/**
 截取NSString变量的后几位
 
 @param stringValue 源变量
 @param aScale 小数点后面多少位
 @return 向下取正后的值
 */
+(NSString *)CCW_decimalSubScaleString:(NSString *)stringValue scale:(NSInteger) aScale
{
    NSDecimalNumber *decimaNumer = [self CCW_decimalNumberWithString:stringValue];
    return [self CCW_decimalSubScale:decimaNumer scale:aScale].stringValue;
}

#pragma mark - Private
// Rounding policies :
// Original
//    value 1.2  1.21  1.25  1.35  1.27
// Plain    1.2  1.2   1.3   1.4   1.3  四舍五入
// Down     1.2  1.2   1.2   1.3   1.2  向下取正
// Up       1.2  1.3   1.3   1.4   1.3  向上取正
// Bankers  1.2  1.2   1.2   1.4   1.3  (特殊的四舍五入，碰到保留位数后一位的数字为5时，根据前一位的奇偶性决定。为偶时向下取正，为奇数时向上取正。如：1.25保留1为小数。5之前是2偶数向下取正1.2；1.35保留1位小数时。5之前为3奇数，向上取正1.4）
+(NSDecimalNumber *)CCW_decimalSubScale:(NSDecimalNumber *)aDecimalNumber scale:(NSInteger) aScale
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:aScale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [aDecimalNumber decimalNumberByRoundingAccordingToBehavior:roundUp];
    return number;
}

@end
