//
//  CocosWalletApi.m
//  WalletInvoker
//
//  Created by 邵银岭 on 2020/1/7.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CocosWalletApi.h"
#import "CCWInvokerLoginViewController.h"
#import "CCWInvokerTransferViewController.h"
#import "CCWInvokerCallContractViewController.h"

static const NSString *kReqRespParam  = @"param";

// 钱包scheme
static NSString *schame_for_wallet = @"CocosBCXWallet";

static NSString *callback_schema = nil;

@implementation CocosWalletApi

/**  发起请求 */
+ (BOOL)sendObj:(CocosResponseObj *)obj {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"result"] = @(obj.result);
    params[@"action"] = obj.action;
    params[@"data"] = obj.data;
    params[@"message"] = obj.message;
    // JSON -> String
    NSString *JSONString = [self toJSONString:params];
    // api
    NSString *URLString = [NSString stringWithFormat:@"%@=%@", obj.callbackSchema, JSONString];
    return [self openURLWithString:URLString];
}

/**  处理TP的回调跳转 */
+ (BOOL)handleURL:(NSURL *)url
          options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if (url.scheme && [url.scheme isEqualToString:schame_for_wallet])
    {
        NSString *host = url.host ?: @"";
        // url 解析转 对象
        NSString *query = [url.query stringByRemovingPercentEncoding] ?: @"";
        NSRange begin = [query rangeOfString:[NSString stringWithFormat:@"%@={", kReqRespParam]];
        if (begin.location == NSNotFound) {
            return NO;
        }else{
            NSString *JSONString = [query substringFromIndex:begin.location + begin.length - 1];
            NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
            
            // 1.获取导航栏控制器
            UITabBarController *rootController = (UITabBarController *)CCWKeyWindow.rootViewController;
            UIViewController *ViewController = [rootController.childViewControllers firstObject];
            // url 解析转 对象 -> 处理逻辑
            if (host && [host isEqualToString:kCocosSDKActionLogin]) {
                // 登录的
                CocosLoginObj *loginObj = [CocosLoginObj mj_objectWithKeyValues:dic];
                
                CCWInvokerLoginViewController *invokerLoginVC = [[CCWInvokerLoginViewController alloc] init];
                invokerLoginVC.loginModel = loginObj;
                [ViewController presentViewController:invokerLoginVC animated:YES completion:nil];
            }else if (host && [host isEqualToString:kCocosSDKActionTransfer]) {
                // 转账的
                CocosTransferObj *transferObj = [CocosTransferObj mj_objectWithKeyValues:dic];
                
                CCWInvokerTransferViewController *transferVC = [[CCWInvokerTransferViewController alloc] init];
                [ViewController presentViewController:transferVC animated:YES completion:nil];
                // 还要比较 from
            }else if (host && [host isEqualToString:kCocosSDKActionCallContract]) {
                // 调用合约的
                CocosCallContractObj *callContract = [CocosCallContractObj mj_objectWithKeyValues:dic];
                CCWInvokerCallContractViewController *callContractVC = [[CCWInvokerCallContractViewController alloc] init];
                [ViewController presentViewController:callContractVC animated:YES completion:nil];
            }else{
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - Private -

/**  跳转 CocosWallet App */
+ (BOOL)openURLWithString:(NSString *)URLString {
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:URLString];
    
    // iOS 10 code
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsOpenInPlaceKey:@"1"}completionHandler:^(BOOL success) {
            //回调
            if(!success) {
                NSLog(@"没有安装DApp 的App 有点扯淡....");
            }else{
                NSLog(@"success");
            }
        }];
    } else {
        // Fallback on earlier versions
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            NSLog(@"没有安装DApp 的App 有点扯淡....");
        }
    }
    
    return NO;
}

/**  转换成json string. */
+ (NSString *)toJSONString:(id)object {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:NULL];
    NSString *JSONString = nil;
    if (data) JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return JSONString;
}
@end
