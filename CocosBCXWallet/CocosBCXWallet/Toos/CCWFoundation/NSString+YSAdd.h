//
//  NSString+YSAdd.h
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (YSAdd)

/**
 //获取某个字符串或者汉字的首字母
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;

/**
 随机字符串 - 生成指定长度的字符串
 @param len <#len description#>
 @return <#return value description#>
 */
+(NSString *)randomStringWithLength:(NSInteger)len ;
+(NSString *)randomNumberStringWithLength:(NSInteger)len ;


// 字符串转为字典
-(NSDictionary *) dictionaryValue;

#pragma 正则匹配数字
+(BOOL)checkNumber:(NSString *)num;
/**
 *  判断是否为空字符串
 *
 *  @param value 待判断的NSString
 *
 *  @return 返回YES或NO
 */
+ (BOOL)ys_isNullOrEmpty:(NSString *)value;
/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/** URLDecode */
-(NSString *)URLDecodedString;
/**
 *  @brief 是否包含字符串
 *
 *  @param string 字符串
 *
 *  @return YES, 包含;
 */
- (BOOL)ys_containsaString:(NSString *)string;

- (NSString *)ys_trim;


- (NSInteger)ys_length;

/**
 忽略字符串的前后空格并计算长度
 
 @return 字符串长度
 */
- (NSInteger)ys_lengthIgnoreTrim;

// 正则有效性
- (BOOL)ys_regexValidate:(NSString *)regex;

#pragma 正则匹配EOS
+ (BOOL)checkEOSAccount : (NSString *) userName;

// 钱包地址有效性（0X 开头，42位，16进制）
//- (BOOL)ys_ValidateWalletAddress;


/** 获取字符串Size */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;
/** 获取字符串height */
- (CGFloat)heightWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth;
/** 获取字符串width */
- (CGFloat)widthWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth;

/**
 *  获取字符串Size
 */
- (CGSize)ys_textSizeWithConstrainedToSize:(CGSize)size font:(UIFont *)font;
- (CGSize)ys_textSizeWithConstrainedToSize:(CGSize)size attributes:(NSDictionary *)attributes;

/**
 *  XML字符串转HTML字符串
 *
 *  @return HTML字符串
 */
- (NSString *)stringByDecodingXMLEntities;

- (NSString *)ys_stringByAppendingPathScale:(CGFloat)scale;

// 是否有表情
// 此处有bug:此方法会过滤9宫格输入法
- (BOOL)ys_containsEmoji;
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)UUIDTimestamp;
/**
 *
 *  @brief  当前时间戳 例如 1443066826
 *
 *  @return 秒级时间戳
 */
+ (NSString *)currentTimestamp;

/**
 零时区时间戳
 */
+ (NSString *)zone0currentTimestamp;

// 当前时区与零时区的间隔秒数
+ (NSInteger)currentZoneSeconds;

#pragma mark - 将某个时间转化成 时间戳
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime;

// 十六进制字符串转数字
- (NSInteger)hexStringToHexNumber;

// 数字转十六进制字符串
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;

// 检测手机号码格式的参考示范
- (BOOL)checkPhoneNumFormat:(NSString *)num;

//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+(NSString*)RemoveSpecialCharacter: (NSString *)str;
@end
