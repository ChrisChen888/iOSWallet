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
    }
}

#pragma mark - Action
+ (void)JS_publishVotes:(NSDictionary *)param addPassword:(NSString *)password response:(CallbackBlock)block {
    NSDictionary *publishParam = param[@"params"];
    
    NSArray *committeeIds = publishParam[@"committee_ids"];
    NSArray *witnessesIds = publishParam[@"witnessesIds"];
    if (IsArrEmpty(committeeIds)) {
        committeeIds = @[];
    }
    if (IsArrEmpty(witnessesIds)) {
        witnessesIds = @[];
    }
    NSString *votes = [NSString stringWithFormat:@"%@",publishParam[@"votes"]];
    
    [CCWSDKRequest CCW_PublishVotes:CCWAccountName CommitteeIds:committeeIds WitnessesIds:witnessesIds Password:password Votes:votes Success:^(id  _Nonnull responseObject) {
        NSDictionary *jsMessage = @{
                                    @"trx_id":responseObject,
                                    };
        !block?:block(@{@"data":@[],@"code":@1,@"trx_data":jsMessage} );
    } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
        !block?:block([self errorBlockWithError:errorAlert ResponseObject:error]);
    }];
}

// 获取账号信息
+ (void)js_getCocosAccount:(NSDictionary *)param response:(CallbackBlock)block{
    NSDictionary *jsMessage = @{
                                @"account_id":CCWAccountId,
                                @"account_name":CCWAccountName
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
    return @{
             @"message":errorObj.domain.description,
             @"code":@(errorObj.code)
             };
}
@end
