//
//  CCWDappWebTool.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/5/13.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWDappWebTool.h"
#import "CCWAssetsModel.h"
#import "CCWPwdAlertView.h"

@implementation CCWDappWebTool


+ (void)JSHandle_ReceiveMessageBody:(NSDictionary *)body
                           password:(NSString *)password
                           response:(CallbackBlock)block
{
    if ([body[@"methodName"] isEqualToString:JS_METHOD_getCocosAccount]) {
        [self js_getCocosAccount:body response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_transfer]) {
        [self JS_transfer:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_callContract]) {
        [self JS_callContract:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_decodeMemo]) {
        [self JS_DecodeMemo:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_transferNH]) {
        [self JS_TransferNHAsset:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_fillNHAssetOrder]) {
        [self JS_fillNHAssetOrder:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_publishVotes]) {
        [self JS_publishVotes:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_claimVestingBalance]) {
        [self JS_ClaimVestingBalance:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_updateCollateralForGas]) {
        [self JS_updateCollateralForGas:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_signString]) {
        [self JS_signString:body addPassword:password response:block];
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_walletLanguage]) {
        if ([[CCWLocalizableTool userLanguage] isEqualToString:CCWLanzh]) {// 中文
            !block?:block(@{@"data":@"cn",@"code":@(1)} );
        }else{
            !block?:block(@{@"data":@"en",@"code":@(1)} );
        }
    }
}

#pragma mark - Action
+ (void)JS_signString:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block {
    NSDictionary *signStringParam = param[@"params"];
    NSString *signString = signStringParam[@"string"];
    [CCWSDKRequest CCW_SignString:CCWAccountName Password:password string:signString Success:^(id  _Nonnull responseObject) {
        !block?:block(responseObject);
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

+ (void)JS_updateCollateralForGas:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block {
    NSDictionary *updateGasParam = param[@"params"];
    
    NSString *mortgager = updateGasParam[@"mortgager"];
    NSString *beneficiary = updateGasParam[@"beneficiary"];
    NSNumber *amount = updateGasParam[@"amount"];
    [CCWSDKRequest CCW_GasWithMortgager:mortgager Beneficiary:beneficiary Collateral:[[NSString stringWithFormat:@"%@",amount] floatValue] Password:password Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage} );
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

+ (void)JS_ClaimVestingBalance:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block {
    NSDictionary *publishParam = param[@"params"];
    NSArray *vestingids = publishParam[@"id"];
    
    for (NSString *vestingid in vestingids) {
        [CCWSDKRequest CCW_ClaimVestingBalance:CCWAccountName Password:password VestingID:vestingid Success:^(id  _Nonnull responseObject) {
            NSDictionary *jsMessage = @{
                                        @"trx_id":responseObject,
                                        };
            !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage} );
        } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
            
            if ([error.userInfo[@"message"] containsString:@"vbo.is_withdraw_allowed"]){
                !block?:block(@{
                                @"message":@"No reward available",
                                @"code":@(127)
                                });
                return;
            }else if ([error.userInfo[@"message"] containsString:@"vbo.owner"]) {
                !block?:block(@{
                                @"message":@"Not reward owner",
                                @"code":@(115)
                                });
                return;
            }
            !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
        }];
    }
}

+ (void)JS_publishVotes:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block {
    NSDictionary *publishParam = param[@"params"];
    
    NSString *voteStrType = publishParam[@"type"];
    NSArray *voteIds = publishParam[@"vote_ids"];
    NSString *votes = [NSString stringWithFormat:@"%@",publishParam[@"votes"]];
    
    int voteType = 1;
    if ([voteStrType isEqualToString:@"witnesses"]) {
        voteType = 1;
    }else if([voteStrType isEqualToString:@"committee"]) {
        voteType = 0;
    }
    
    // 投 0 票数组传@[]
    if ([votes isEqualToString:@"0"]) {
        voteIds = @[];
    }
    
    [CCWSDKRequest CCW_PublishVotes:CCWAccountName Password:password VoteType:voteType VoteIds:voteIds Votes:votes Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage} );
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 获取账号信息
+ (void)js_getCocosAccount:(NSDictionary *)param response:(CallbackBlock)block{
    NSDictionary *jsMessage = @{
                                @"account_id":CCWAccountId?:@"",
                                @"account_name":CCWAccountName?:@""
                                };
    !block?:block(jsMessage);
}


// 转账
+ (void)JS_transfer:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block
{   
    NSDictionary *transferParam = param[@"params"];
    NSString *from = transferParam[@"fromAccount"];
    NSString *to = transferParam[@"toAccount"];
    NSString *amount = transferParam[@"amount"];
    NSString *assetId = transferParam[@"assetId"];
    NSString *memo = transferParam[@"memo"];
    
    [CCWSDKRequest CCW_TransferAsset:from toAccount:to password:password assetId:assetId  amount:amount memo:memo Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage} );
    } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 调用合约
+ (void)JS_callContract:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block
{
    NSDictionary *callContractParam = param[@"params"];
    NSString *nameOrId = callContractParam[@"nameOrId"];
    NSString *functionName = callContractParam[@"functionName"];
    NSArray *valueList = callContractParam[@"valueList"];
    [CCWSDKRequest CCW_CallContract:nameOrId ContractMethodParam:valueList ContractMethod:functionName CallerAccount:CCWAccountName Password:password CallContractSuccess:^(id  _Nonnull responseObject) {
        !block?:block(responseObject);
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 解密备注
+ (void)JS_DecodeMemo:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block
{
    NSDictionary *memoParam = param[@"params"];
    NSDictionary *memoDic = memoParam;
    [CCWSDKRequest CCW_DecodeMemo:memoDic Password:password Success:^(id  _Nonnull responseObject) {
        !block?:block(@{@"data":@{@"text":responseObject},@"code":@1});
    } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 转移资产
+ (void)JS_TransferNHAsset:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block
{
    NSDictionary *trnhParam = param[@"params"];
    NSString *toAccount = trnhParam[@"toAccount"];
    NSArray *NHAssetIds = trnhParam[@"NHAssetIds"];
    [CCWSDKRequest CCW_TransferNHAssetToAccount:toAccount NHAssetID:[NHAssetIds firstObject] Password:password Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage});
    } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

//  购买NH资产
+ (void)JS_fillNHAssetOrder:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block
{
    NSDictionary *nhassetParam = param[@"params"];
    NSString *orderId = nhassetParam[@"orderId"];
    
    
    [CCWSDKRequest CCW_BuyNHAssetOrderID:orderId Account:CCWAccountName Password:password Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage});
    } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 所有错误处理
+ (NSDictionary *)errorBlockWithError:(NSString *)error ResponseObject:(NSError *)errorObj
{
    NSString *message = errorObj.userInfo[@"message"];
    message = [message stringByReplacingOccurrencesOfString:@"\'" withString:@"’"];
    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"’"];
    if (message) {
        return @{
                 @"message":message,
                 @"code":errorObj.userInfo[@"code"]
                 };
    }else{
        return @{
                 @"message":errorObj.domain.description,
                 @"code":@(errorObj.code)
                 };
    }
}
@end
