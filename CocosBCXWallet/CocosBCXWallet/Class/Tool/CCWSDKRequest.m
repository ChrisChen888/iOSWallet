//
//  CCWSDKRequest.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/28.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSDKRequest.h"
#import "CCWSDKErrorHandle.h"
#import "CCWAssetsModel.h"
#import "CCWTransRecordModel.h"
#import "CCWWalletAccountModel.h"
#import "CCWNHAssetOrderModel.h"

@implementation CCWSDKRequest

/** 查询后台配置节点信息 */
+ (void)CCW_RequestNodeSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock
{
    [[CocosHTTPManager CCW_shareHTTPManager] CCW_GET:@"http://backend.test.cjfan.net/getParams" Param:nil Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];

}

/**
 库传参初始化

 @param url api节点
 @param core_asset 链标识
 @param faucetUrl 地址
 @param chainId 链接
 */
+ (void)CCW_InitWithUrl:(NSString *)url
             Core_Asset:(NSString *)core_asset
             Faucet_url:(NSString *)faucetUrl
                ChainId:(NSString *)chainId
                Success:(SuccessBlock)successBlock
                  Error:(ErrorBlock)errorBlock
{
//    [[CocosSDK shareInstance] Cocos_OpenLog:YES];
    [[CocosSDK shareInstance] Cocos_ConnectWithNodeUrl:url Fauceturl:faucetUrl TimeOut:5 CoreAsset:core_asset ChainId:chainId ConnectedStatus:^(WebsocketConnectStatus connectStatus) {
        if (connectStatus == WebsocketConnectStatusConnected) {
            !successBlock?:successBlock(@"connect success");
        }else{
            !errorBlock?:errorBlock(@"connect error",[NSError new]);
        }
    }];
}

/** 查询版本信息 */
+ (void)CCW_QueryVersionInfoSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock;
{
    [[CocosHTTPManager CCW_shareHTTPManager] CCW_GET:@"http://backend.test.cjfan.net/getPolicyUrl?channel=1001&platform=iOS" Param:nil Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/** 查询发现页 */
+ (void)CCW_QueryFindDappListSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock
{
    [[CocosHTTPManager CCW_shareHTTPManager] CCW_GET:@"http://backend.test.cjfan.net/getBanInfo" Param:nil Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}


/**
 创建账户

 @param userName 用户名
 @param pwd 密码
 */
+ (void)CCW_CreateAccountWithWallet:(NSString *)userName
                           password:(NSString *)pwd
                         walletMode:(CocosWalletMode)walletMode
                          autoLogin:(BOOL)autoLogin
                            Success:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_CreateAccountWalletMode:walletMode AccountName:userName Password:pwd AutoLogin:autoLogin Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 登录账号

 @param userName 用户名
 @param pwd 密码
 */
+ (void)CCW_PasswordLogin:(NSString *)userName
             password:(NSString *)pwd
              Success:(SuccessBlock)successBlock
                Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_LoginAccountWithName:userName Password:pwd Success:^(id responseObject) {
        [[CocosSDK shareInstance] Cocos_GetDBAccount:userName Success:^(CocosDBAccountModel * dbAccount) {
            !successBlock?:successBlock(@{@"account":userName,@"id":dbAccount.ID});
        } Error:^(NSError *error) {
            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
        }];
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 通过私钥登录

 @param privateKey 私钥
 @param password 密码
 */
+ (void)CCW_PrivateKeyLogin:(NSString *)privateKey
                   password:(NSString *)password
                    Success:(SuccessBlock)successBlock
                      Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_ImportWalletWithPrivate:privateKey WalletMode:CocosWalletModeAccount TempPassword:password Success:^(id responseObject) {
        [[CocosSDK shareInstance] Cocos_GetDBAccount:responseObject Success:^(CocosDBAccountModel * dbAccount) {
            !successBlock?:successBlock(@{@"account":responseObject,@"id":dbAccount.ID});
        } Error:^(NSError *error) {
            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
        }];

    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}


/**
 退出登录
 */
+ (void)CCW_LogoutAccount:(NSString *)accountName
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_DeleteWalletAccountName:accountName Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}


/**
 修改密码
 @param oldPassword 原始密码/导入ownerPrivateKey设置的临时密码
 @param newPassword 新密码
 */
+ (void)CCW_ChangePassword:(NSString *)oldPassword
               newPassword:(NSString *)newPassword
                   Success:(SuccessBlock)successBlock
                     Error:(ErrorBlock)errorBlock
{
//    [[bcxObject sharedInstance] changePassword:oldPassword newPassword:newPassword Callback:^(NSDictionary *responseDict) {
//        NSString *code =  responseDict[@"code"];
//        if ([code integerValue] == 1) {
//            !successBlock?:successBlock(responseDict[@"data"]);
//        }else{
//            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:responseDict],responseDict);
//        }
//    }];
}

/**
 获取私钥
 */
+ (void)CCW_GetPrivateKey:(NSString *)accountName
                 password:(NSString *)password
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock
{

    [[CocosSDK shareInstance] validateAccount:accountName Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 查询账户信息
 @param account 帐号
 */
+ (void)CCW_QueryAccountInfo:(NSString *)account
                     Success:(SuccessBlock)successBlock
                       Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetAccount:account Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 查询账户记录
 
 @param accountId 账号
 @param limit 条数
 */
+ (void)CCW_QueryUserOperations:(NSString *)accountId
                          limit:(NSInteger)limit
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetAccountHistory:accountId Limit:limit Success:^(id responseObject) {
        NSMutableArray *transRecordModelArray = [CCWTransRecordModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (transRecordModelArray.count == 0) {
            !successBlock?:successBlock(transRecordModelArray);
            return;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_t disp = dispatch_semaphore_create(0);
            for (CCWTransRecordModel * transRecordModel in transRecordModelArray) {
                NSDictionary *resultDic = [transRecordModel.result lastObject];
                transRecordModel.fees = [CCWAmountFee mj_objectArrayWithKeyValuesArray:resultDic[@"fees"]];
                NSNumber *operationType = [transRecordModel.op firstObject];
                __block CCWOperation *operation = [CCWOperation mj_objectWithKeyValues:[transRecordModel.op lastObject]];
                if ([operationType integerValue] == 0 || [operationType integerValue] == 42) {
                    transRecordModel.oprationType = [operationType integerValue];
                    // 用ID 查用户名
                    NSString *transferID = @"";
                    if ([operation.from isEqualToString:CCWAccountId]) {
                        transRecordModel.from = CCWAccountName;
                        transferID = operation.to;
                    }else{
                        transRecordModel.to = CCWAccountName;
                        transferID = operation.from;
                    }
                    // 查询用户信息
                    [self CCW_QueryAccountInfo:transferID Success:^(id  _Nonnull responseObject) {
                        if ([transRecordModel.from isEqualToString:CCWAccountName]) {
                            transRecordModel.to = responseObject[@"name"];
                        }else{
                            transRecordModel.from = responseObject[@"name"];
                        }
                        // 查询时间
                        [[CocosSDK shareInstance] Cocos_GetBlockHeaderWithBlockNum:transRecordModel.block_num Success:^(id responseObject) {
                            transRecordModel.timestamp = responseObject[@"timestamp"];
                            if ([operationType integerValue] == 0) {
                                // 查询转账币种信息
                                [self CCW_QueryAssetInfo:operation.amount.asset_id Success:^(CCWAssetsModel *assetsModel) {
                                    operation.amount.symbol = assetsModel.symbol;
                                    operation.amount.precision = assetsModel.precision;
                                    operation.amount.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",operation.amount.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
                                    transRecordModel.operation = operation;
                                    dispatch_semaphore_signal(disp);
                                } Error:errorBlock];
                            }else{
                                transRecordModel.operation = operation;
                                dispatch_semaphore_signal(disp);
                            }
                        } Error:^(NSError *error) {
                            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
                        }];

                    } Error:errorBlock];
                }else if ([operationType integerValue] == 35) {
                    
                    transRecordModel.operation = operation;
                    transRecordModel.oprationType = CCWOpTypeCallContract;
                    transRecordModel.caller = CCWAccountName;
                    // 用ID 查用户名
                    NSString *contractID = operation.contract_id;
                    // 查询合约信息
                    [[CocosSDK shareInstance] Cocos_GetContract:contractID Success:^(id contractRes) {
                        transRecordModel.contractInfo = [CCWContractInfo mj_objectWithKeyValues:contractRes];
                        [[CocosSDK shareInstance] Cocos_GetBlockHeaderWithBlockNum:transRecordModel.block_num Success:^(id responseObject) {
                            transRecordModel.timestamp = responseObject[@"timestamp"];
                            dispatch_semaphore_signal(disp);
                        } Error:^(NSError *error) {
                            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
                        }];
                    } Error:^(NSError *error) {
                        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
                    }];
                }else{
                    transRecordModel.oprationType = CCWOpTypeNoKnow;// 未处理类型
                    dispatch_semaphore_signal(disp);
                }
                // 2. 等待信号
                dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                !successBlock?:successBlock(transRecordModelArray);
            });
        });
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 转账 客户的可以通过获取的资产列表先校验对应资产余额是否足够
 @param fromAccount 来源帐号
 @param toAccount 转给目标账号
 @param assetId 资产Id 通过 getBalances先获取资产列表
 @param amount 转账数量
 @param memo 备注说明
 */
+ (void)CCW_TransferAsset:(NSString *)fromAccount
                toAccount:(NSString *)toAccount
                 password:(NSString *)password
                  assetId:(NSString *)assetId
                   amount:(NSString *)amount
                     memo:(NSString *)memo
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_TransferFromAccount:fromAccount ToAccount:toAccount Password:password TransferAsset:assetId AssetAmount:amount Memo:memo Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}


/**
 查询账户拥有的所有资产列表
 @param accountID 账户ID
 */
+ (void)CCW_QueryAccountAllBalances:(NSString *)accountID
                            Success:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetAccountBalance:accountID CoinID:@[] Success:^(NSArray *responseObject) {
        NSMutableArray *myassetArr = [CCWAssetsModel mj_objectArrayWithKeyValuesArray:responseObject];
        __block NSMutableArray *tempArray = [NSMutableArray array];
        if (myassetArr.count == 0) {
            !successBlock?:successBlock(tempArray);
            return;
        }
        [myassetArr enumerateObjectsUsingBlock:^(CCWAssetsModel *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [self CCW_QueryAssetInfo:asset.asset_id Success:^(CCWAssetsModel *assetsModel) {
                assetsModel.asset_id = asset.asset_id;
                assetsModel.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",asset.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
                [tempArray addObject:assetsModel];
                if (tempArray.count == myassetArr.count) {
                    !successBlock?:successBlock(tempArray);
                }
            } Error:errorBlock];
        }];
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 查询资产信息
 
 @param assetID 资产ID
 */
+ (void)CCW_QueryAssetInfo:(NSString *)assetID
                   Success:(SuccessBlock)successBlock
                     Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetAsset:assetID Success:^(id assetDic) {
        CCWAssetsModel *assetsModel = [CCWAssetsModel mj_objectWithKeyValues:assetDic];
        !successBlock?:successBlock(assetsModel);
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 查询账户指定资产

 @param accountID 账号ID
 @param assetId 资产id

 */
+ (void)CCW_QueryAccountBalances:(NSString *)accountID
                         assetId:(NSString *)assetId
                         Success:(SuccessBlock)successBlock
                           Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetAccountBalance:accountID CoinID:@[assetId] Success:^(id responseObject) {
        CCWAssetsModel *assetAmountModel = [CCWAssetsModel mj_objectWithKeyValues:[responseObject firstObject]];
        [self CCW_QueryAssetInfo:assetId Success:^(CCWAssetsModel *assetsModel) {
            assetsModel.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",assetAmountModel.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
            !successBlock?:successBlock(assetsModel);
        } Error:errorBlock];
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

/**
 备注解密

 @param memo 备注
 */
+ (void)CCW_DecodeMemo:(NSDictionary *)memo
              Password:(NSString *)password
               Success:(SuccessBlock)successBlock
                 Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_DecryptMemo:memo AccountName:CCWAccountName Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}


/** 查询账户列表 */
+ (NSMutableArray *)CCW_QueryAccountList
{
    return [[CocosSDK shareInstance] Cocos_QueryAllDBAccountInfo];
}

/** 查询账户列包括资产信息 */
+ (void)CCW_QueryAccountListSuccess:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock
{
    NSArray *accountArray = [[CocosSDK shareInstance] Cocos_QueryAllDBAccountInfo];
    NSMutableArray *tempArray = [NSMutableArray array];
    if (accountArray.count == 0) {
        !successBlock?:successBlock(tempArray);
        return;
    }
    [accountArray enumerateObjectsUsingBlock:^(CocosDBAccountModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCWWalletAccountModel *walletAccount = [[CCWWalletAccountModel alloc] init];
        walletAccount.dbAccountModel = obj;
        [[CocosSDK shareInstance] Cocos_GetAccountBalance:obj.ID CoinID:@[@"1.3.0"] Success:^(NSArray *responseObject) {
            CCWAssetsModel *walletAccountAsset = [CCWAssetsModel mj_objectWithKeyValues:[responseObject lastObject]];
            [self CCW_QueryAssetInfo:walletAccountAsset.asset_id Success:^(CCWAssetsModel *assetsModel) {
                walletAccountAsset.symbol = assetsModel.symbol;
                walletAccountAsset.precision = assetsModel.precision;
                walletAccountAsset.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",walletAccountAsset.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
                walletAccount.cocosAssets = walletAccountAsset;
                [tempArray addObject:walletAccount];
                if (tempArray.count == accountArray.count) {
                    !successBlock?:successBlock(tempArray);
                }
            } Error:errorBlock];
        } Error:^(NSError *error) {
            !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
        }];
    }];
}

/** 调用合约手续费 */
+ (void)CCW_CallContractFee:(NSString *)contractIdOrName
        ContractMethodParam:(NSArray *)param
             ContractMethod:(NSString *)contractmMethod
              CallerAccount:(NSString *)accountIdOrName
             feePayingAsset:(NSString *)feePayingAsset
                   Password:(NSString *)password
        CallContractSuccess:(SuccessBlock)successBlock
                      Error:(ErrorBlock)errorBlock
{
//    [[CocosSDK shareInstance] Cocos_GetCallContractFee:contractIdOrName ContractMethodParam:param ContractMethod:contractmMethod CallerAccount:accountIdOrName feePayingAsset:feePayingAsset Success:^(id responseObject) {
//        CCWAssetsModel *assetAmountModel = [CCWAssetsModel mj_objectWithKeyValues:[responseObject firstObject]];
//        [self CCW_QueryAssetInfo:feePayingAsset Success:^(CCWAssetsModel *assetsModel) {
//            assetsModel.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",assetAmountModel.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
//            !successBlock?:successBlock(assetsModel);
//        } Error:errorBlock];
//    } Error:^(NSError *error) {
//        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
//    }];
}

/** 调用合约 */
+ (void)CCW_CallContract:(NSString *)contractIdOrName
     ContractMethodParam:(NSArray *)param
          ContractMethod:(NSString *)contractmMethod
           CallerAccount:(NSString *)accountIdOrName
                Password:(NSString *)password
     CallContractSuccess:(SuccessBlock)successBlock
                   Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_CallContract:contractIdOrName ContractMethodParam:param ContractMethod:contractmMethod CallerAccount:accountIdOrName Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询合约信息
+ (void)CCW_queryContra:(NSString *)contractIdOrName
               Success:(SuccessBlock)successBlock
                 Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetContract:contractIdOrName Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// dapp 查询账户信息queryAccountInfo
+ (void)CCW_queryFullAccountInfo:(NSString *)contractIdOrName
                 Success:(SuccessBlock)successBlock
                   Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GetFullAccount:contractIdOrName Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询NH资产详细信息
+ (void)CCW_queryNHAssets:(NSArray *)hashOrId
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_LookupNHAsset:hashOrId Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询账户下所拥有的NH资产售卖订单
+ (void)CCW_ListAccountNHAssetOrder:(NSString *)accountID
                             PageSize:(NSInteger)pageSize
                                 Page:(NSInteger)page
                            Success:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_ListAccountNHAssetOrder:accountID PageSize:pageSize Page:page Success:^(NSArray *responseObject) {
        [self queryNHOrderResultHandle:responseObject Success:successBlock Error:errorBlock];
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询全网NH资产售卖订单
+ (void)CCW_QueryAllNHAssetOrder:(NSString *)assetid
                       WorldView:(NSString *)worldViewIDOrName
                    BaseDescribe:(NSString *)baseDescribe
                        PageSize:(NSInteger)pageSize
                            Page:(NSInteger)page
                         Success:(SuccessBlock)successBlock
                           Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_AllListNHAssetOrder:assetid WorldView:worldViewIDOrName BaseDescribe:baseDescribe PageSize:pageSize Page:page Success:^(NSArray *responseObject) {
        [self queryNHOrderResultHandle:responseObject Success:successBlock Error:errorBlock];
    } Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询资产后处理
+ (void)queryNHOrderResultHandle:(NSArray *)responseObject
                         Success:(SuccessBlock _Nonnull)successBlock
                           Error:(ErrorBlock _Nonnull)errorBlock
{
    NSMutableArray *myassetArr = [CCWNHAssetOrderModel mj_objectArrayWithKeyValuesArray:[responseObject firstObject]];
    __block NSMutableArray *tempArray = [NSMutableArray array];
    if (myassetArr.count == 0) {
        !successBlock?:successBlock(tempArray);
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t disp = dispatch_semaphore_create(0);
        for (CCWNHAssetOrderModel *nhAssetOrder in myassetArr) {
            // 查询卖家
            [self CCW_QueryAccountInfo:nhAssetOrder.seller Success:^(id  _Nonnull responseObject) {
                // 用户名称
                nhAssetOrder.sellername = responseObject[@"name"];
                // 查询转账币种信息
                [self CCW_QueryAssetInfo:nhAssetOrder.price[@"asset_id"] Success:^(CCWAssetsModel *assetsModel) {
                    nhAssetOrder.priceModel = assetsModel;
                    nhAssetOrder.priceModel.amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",nhAssetOrder.price[@"amount"]]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
                    [tempArray addObject:nhAssetOrder];
                    dispatch_semaphore_signal(disp);
                } Error:errorBlock];
            } Error:errorBlock];
            // 2. 等待信号
            dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !successBlock?:successBlock(tempArray);
        });
    });
}

// 查询账户所拥有的非同质资产
+ (void)CCW_QueryAccountNHAsset:(NSString *)accountID
                      WorldView:(NSArray *)worldViewIDArray
                       PageSize:(NSInteger)pageSize
                           Page:(NSInteger)page
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock
{
    
    [[CocosSDK shareInstance] Cocos_ListAccountNHAsset:accountID WorldView:worldViewIDArray PageSize:pageSize Page:page Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 购买NH资产
+ (void)CCW_BuyNHAssetOrderID:(NSString *)orderID
                      Account:(NSString *)account
                     Password:(NSString *)password
                      Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_BuyNHAssetOrderID:orderID Account:account Password:password  Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 出售NH资产
+ (void)CCW_SellNHAssetNHAssetId:(NSString *)nhAssetid
                        Password:(NSString *)password
                         Memo:(NSString *)memo
              SellPriceAmount:(NSString *)priceAmount
                    SellAsset:(NSString *)sellAsset
                   Expiration:(NSString *)expiration
                      Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_SellNHAssetSeller:CCWAccountName Password:password NHAssetId:nhAssetid Memo:memo SellPriceAmount:priceAmount PendingFeeAmount:@"0" OperationAsset:@"1.3.0" SellAsset:sellAsset Expiration:expiration Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 出售资产的最大过期时间
+ (void)CCW_SellNHAssetMaxExpirationSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_SellNHAssetMaxExpirationSuccess:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 查询链上发行的资产
+ (void)CCW_QueryChainListLimit:(NSInteger)nLimit
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_ChainListLimit:nLimit Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 取消NH资产
+ (void)CCW_CancelSellNHAssetOrderId:(NSString *)orderId
                            Password:(NSString *)password
                             Success:(SuccessBlock)successBlock
                               Error:(ErrorBlock)errorBlock
{
    
    [[CocosSDK shareInstance] Cocos_CancelNHAssetAccount:CCWAccountName Password:password  OrderId:orderId Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 购买NH资产
+ (void)CCW_BugNHAssetOrderId:(NSString *)orderId
                     Password:(NSString *)password
                      Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_BuyNHAssetOrderID:orderId Account:CCWAccountName Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 删除NH资产
+ (void)CCW_DeleteNHAssetId:(NSString *)nhAssetId
                   Password:(NSString *)password
                    Success:(SuccessBlock)successBlock
                      Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_DeleteNHAssetAccount:CCWAccountName Password:password  nhAssetID:nhAssetId Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

+ (void)CCW_TransferNHAssetToAccount:(NSString *)to
                           NHAssetID:(NSString *)NHAssetID
                            Password:(NSString *)password
                             Success:(SuccessBlock)successBlock
                               Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_TransferNHAsset:CCWAccountName ToAccount:to NHAssetID:NHAssetID Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 投票
+ (void)CCW_PublishVotes:(NSString *)accountName
                Password:(NSString *)password
                VoteType:(int)voteType
                 VoteIds:(NSArray *)voteIds
                   Votes:(NSString *)votes
                 Success:(SuccessBlock)successBlock
                   Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_PublishVotes:accountName Password:password Type:voteType VoteIds:voteIds Votes:votes Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 抵押 Gas
+ (void)CCW_GasWithMortgager:(NSString *)mortgagerAccount
                 Beneficiary:(NSString *)beneficiaryAccount
                  Collateral:(long)collateral
                    Password:(NSString *)password
                     Success:(SuccessBlock)successBlock
                       Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_GasWithMortgager:mortgagerAccount Beneficiary:beneficiaryAccount Collateral:collateral Password:password Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}

// 领取奖励
+ (void)CCW_ClaimVestingBalance:(NSString *)account
                       Password:(NSString *)password
                      VestingID:(NSString *)vesting_id
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock
{
    [[CocosSDK shareInstance] Cocos_ClaimVestingBalance:account Password:password VestingID:vesting_id Success:successBlock Error:^(NSError *error) {
        !errorBlock ?:errorBlock([CCWSDKErrorHandle httpErrorStatusWithCode:@{@"code":@(error.code)}],error);
    }];
}
@end
