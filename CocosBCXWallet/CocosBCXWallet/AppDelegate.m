//
//  AppDelegate.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/1/28.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyBoardManager/IQKeyboardManager.h>
#import "CCWNavigationController.h"

#import "CCWEncryptTool.h"
#import "CCWDataBase+CCWNodeINfo.h"

#import <UMCommon/UMCommon.h>

#import "CocosWalletApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 查询汇率
    [self CCW_RequestExchange];
    
    // 请求连接节点
    [self CCW_RequestNodeInfo];
    
    // 模块注册
    [[CCWMediator sharedInstance] registerAllModules];
    
    // 选择语言
    [CCWLocalizableTool initUserLanguage];
    
    //设置键盘
    [self CCW_KeyBoardSetting];
    
    // 第一次安装默认人民币
    [self CCW_SetCoinType];
    
    // 设置 Toast
    [self CCW_SetToast];
    
#ifdef DEBUG
    
#else
    // 友盟配置
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure initWithAppkey:UMengAppKey channel:nil];
#endif
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置跟控制器
    self.window.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 查询汇率
- (void)CCW_RequestExchange
{
    [CCWSDKRequest CCW_RequestExchangeSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *exchangeResult = responseObject[@"data"];
        NSArray *exchange = exchangeResult[@"result"];
        NSDictionary *usd = [exchange lastObject];
        NSString *exchangerate = usd[@"exchange"];
        [CCWSaveTool setObject:exchangerate forKey:CCWCurrencyValueKey];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        
    }];
}

// 请求连接节点
- (void)CCW_RequestNodeInfo
{
    CCWWeakSelf;
    // 请求连接节点
    [CCWSDKRequest CCW_RequestNodeSuccess:^(id  _Nonnull responseObject) {
        NSMutableArray *nodeArray = [CCWNodeInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        // 重新填入数据库
        [[CCWDataBase CCW_shareDatabase] CCW_SaveSerVerNodeInfoArray:nodeArray];
        [weakSelf connectNodeWithNodeArray:nodeArray];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        NSMutableArray *nodeArray = [[CCWDataBase CCW_shareDatabase] CCW_QueryNodeInfo];
        [weakSelf connectNodeWithNodeArray:nodeArray];
    }];
}

// 连接节点
- (void)connectNodeWithNodeArray:(NSArray *)nodeArray
{
    NSString *perConnectChainId = @"";
    CCWNodeInfoModel  *nodeInfo = [nodeArray firstObject];
    if (CCWNodeInfo) {
        nodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
        perConnectChainId = nodeInfo.chainId;
    }
    for (CCWNodeInfoModel *enumNodeInfo in nodeArray) {
        if (enumNodeInfo.isForce) {
            nodeInfo = enumNodeInfo;
            break;
        }
    }
    
    // 节点类型
    CCWNetNotesType = nodeInfo.type;
    
    CCWWeakSelf
    // 最新新节点
    [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
        // 记录已连接的数据
        CCWSETNodeInfo([nodeInfo mj_keyValues]);
        
        // 上次连的链接和本次连得不一样判断
        if (![perConnectChainId isEqualToString:nodeInfo.chainId]) {
            // 判断当前链是否已经有账户
            NSArray *accountArray = [CCWSDKRequest CCW_QueryAccountList];
            if (accountArray.count > 0) {
                CocosDBAccountModel *dbAccountModel = [accountArray firstObject];
                CCWSETAccountName(dbAccountModel.name);
                CCWSETAccountId(dbAccountModel.ID);
            }else{
                CCWSETAccountName(nil);
                CCWSETAccountId(nil);
            }
        }
        // 发个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
        [CocosSDK shareInstance].connectStatusChange = ^(WebsocketConnectStatus status) {
            if (status == WebsocketConnectStatusClosed) {
                [weakSelf connectNodeWithNodeArray:nodeArray];
            }
        };
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        
    }];
}

// 键盘设置
- (void)CCW_KeyBoardSetting
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

// 设置默认货币人民币
- (void)CCW_SetCoinType
{
    NSString *versionInfo = [CCWSaveTool objectForKey:@"CCWAppVersionLanchApp"];
    if (!versionInfo) {// 第一次安装
        [CCWSaveTool setBool:YES forKey:CCWCurrencyType];
        [CCWSaveTool setBool:YES forKey:@"CCWAppVersionLanchApp"];
    }
}

// Toast 配置
- (void)CCW_SetToast
{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.verticalMagin = 50;
    style.backgroundColor = [[UIColor getColor:@"282828"] colorWithAlphaComponent:0.8];
    style.cornerRadius = 3;
    style.messageFont = CCWFont(14);
    
    // @NOTE: Uncommenting the line below will set the shared style for all toast methods:
    [CSToastManager setSharedStyle:style];
    [CSToastManager setDefaultPosition:CSToastPositionBottom];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [CocosWalletApi handleURL:url options:options];   
}

@end
