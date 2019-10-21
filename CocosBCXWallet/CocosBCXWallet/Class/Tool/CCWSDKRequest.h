//
//  CCWSDKRequest.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/28.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocosSDK.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessBlock)(id responseObject);// 成功回调
typedef void (^ErrorBlock)(NSString *errorAlert,id responseObject);// 失败回调

@interface CCWSDKRequest : NSObject

/** 查询后台配置节点信息 */
+ (void)CCW_RequestNodeSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock;

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
              Error:(ErrorBlock)errorBlock;

/** 查询版本信息 */
+ (void)CCW_QueryVersionInfoSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock;

/** 查询发现页 */
+ (void)CCW_QueryFindDappListSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock;

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
                              Error:(ErrorBlock)errorBlock;

/**
 登录账号
 
 @param userName 用户名
 @param pwd 密码
 */
+ (void)CCW_PasswordLogin:(NSString *)userName
             password:(NSString *)pwd
              Success:(SuccessBlock)successBlock
                Error:(ErrorBlock)errorBlock;


/**
 通过私钥登录
 
 @param privateKey 私钥
 @param password 密码
 */
+ (void)CCW_PrivateKeyLogin:(NSString *)privateKey
                   password:(NSString *)password
                    Success:(SuccessBlock)successBlock
                      Error:(ErrorBlock)errorBlock;



/**
 退出登录
 */
+ (void)CCW_LogoutAccount:(NSString *)accountName
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock;


/**
 修改密码
 @param oldPassword 原始密码/导入ownerPrivateKey设置的临时密码
 @param newPassword 新密码
 */
+ (void)CCW_ChangePassword:(NSString *)oldPassword
               newPassword:(NSString *)newPassword
                   Success:(SuccessBlock)successBlock
                     Error:(ErrorBlock)errorBlock;


/**
 获取私钥
 */
+ (void)CCW_GetPrivateKey:(NSString *)accountName
                 password:(NSString *)password
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock;



/**
 查询账户信息
 @param account 帐号
 */
+ (void)CCW_QueryAccountInfo:(NSString *)account
                     Success:(SuccessBlock)successBlock
                       Error:(ErrorBlock)errorBlock;

/**
 查询账户记录
 
 @param accountId 账号Id
 @param limit 条数
 */
+ (void)CCW_QueryUserOperations:(NSString *)accountId
                          limit:(NSInteger)limit
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock;

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
                    Error:(ErrorBlock)errorBlock;

/**
 查询账户拥有的所有资产列表

 @param account 账户ID
 */
+ (void)CCW_QueryAccountAllBalances:(NSString *)account
                            Success:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock;
/**
 查询资产信息
 
 @param assetID 资产ID
 */
+ (void)CCW_QueryAssetInfo:(NSString *)assetID
                   Success:(SuccessBlock)successBlock
                     Error:(ErrorBlock)errorBlock;
/**
 查询账户指定资产
 
 @param accountID 账号ID
 @param assetId 资产id
 
 */
+ (void)CCW_QueryAccountBalances:(NSString *)accountID
                         assetId:(NSString *)assetId
                         Success:(SuccessBlock)successBlock
                           Error:(ErrorBlock)errorBlock;


/**
 备注解密
 
 @param memo 备注
 */
+ (void)CCW_DecodeMemo:(NSDictionary *)memo
              Password:(NSString *)password
               Success:(SuccessBlock)successBlock
                 Error:(ErrorBlock)errorBlock;

/** 查询账户列表 */
+ (NSMutableArray *)CCW_QueryAccountList;

/** 查询账户列包括资产信息 */
+ (void)CCW_QueryAccountListSuccess:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock;

/** 调用合约手续费 */
+ (void)CCW_CallContractFee:(NSString *)contractIdOrName
        ContractMethodParam:(NSArray *)param
             ContractMethod:(NSString *)contractmMethod
              CallerAccount:(NSString *)accountIdOrName
             feePayingAsset:(NSString *)feePayingAsset
                   Password:(NSString *)password
        CallContractSuccess:(SuccessBlock)successBlock
                      Error:(ErrorBlock)errorBlock;
/** 调用合约 */
+ (void)CCW_CallContract:(NSString *)contractIdOrName
     ContractMethodParam:(NSArray *)param
          ContractMethod:(NSString *)contractmMethod
           CallerAccount:(NSString *)accountIdOrName
                Password:(NSString *)password
     CallContractSuccess:(SuccessBlock)successBlock
                   Error:(ErrorBlock)errorBlock;
// 查询合约信息
+ (void)CCW_queryContra:(NSString *)contractIdOrName
                Success:(SuccessBlock)successBlock
                  Error:(ErrorBlock)errorBlock;

// dapp 查询账户信息queryAccountInfo
+ (void)CCW_queryFullAccountInfo:(NSString *)contractIdOrName
                 Success:(SuccessBlock)successBlock
                   Error:(ErrorBlock)errorBlock;

// 查询NH资产详细信息
+ (void)CCW_queryNHAssets:(NSArray *)hashOrId
                  Success:(SuccessBlock)successBlock
                    Error:(ErrorBlock)errorBlock;

// 查询账户下所拥有的NH资产售卖订单
+ (void)CCW_ListAccountNHAssetOrder:(NSString *)accountID
                           PageSize:(NSInteger)pageSize
                               Page:(NSInteger)page
                            Success:(SuccessBlock)successBlock
                              Error:(ErrorBlock)errorBlock;
// 查询全网NH资产售卖订单
+ (void)CCW_QueryAllNHAssetOrder:(NSString *)assetid
                       WorldView:(NSString *)worldViewIDOrName
                    BaseDescribe:(NSString *)baseDescribe
                        PageSize:(NSInteger)pageSize
                            Page:(NSInteger)page
                         Success:(SuccessBlock)successBlock
                           Error:(ErrorBlock)errorBlock;

// 查询账户所拥有的道具NH资产
+ (void)CCW_QueryAccountNHAsset:(NSString *)accountID
                      WorldView:(NSArray *)worldViewIDArray
                       PageSize:(NSInteger)pageSize
                           Page:(NSInteger)page
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock;
/**
 购买NH资产
 */
+ (void)CCW_BuyNHAssetOrderID:(NSString *)orderID
                        Account:(NSString *)account
                       Password:(NSString *)password
                        Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock;
// 出售NH资产
+ (void)CCW_SellNHAssetNHAssetId:(NSString *)nhAssetid
                        Password:(NSString *)password
                            Memo:(NSString *)memo
                 SellPriceAmount:(NSString *)priceAmount
                       SellAsset:(NSString *)sellAsset
                      Expiration:(NSString *)expiration
                         Success:(SuccessBlock)successBlock
                           Error:(ErrorBlock)errorBlock;

// 出售资产的最大过期时间
+ (void)CCW_SellNHAssetMaxExpirationSuccess:(SuccessBlock)successBlock Error:(ErrorBlock)errorBlock;

// 查询链上发行的资产
+ (void)CCW_QueryChainListLimit:(NSInteger)nLimit
                        Success:(SuccessBlock)successBlock
                          Error:(ErrorBlock)errorBlock;
// 取消NH资产
+ (void)CCW_CancelSellNHAssetOrderId:(NSString *)orderId
                            Password:(NSString *)password
                             Success:(SuccessBlock)successBlock
                               Error:(ErrorBlock)errorBlock;

// 购买NH资产
+ (void)CCW_BugNHAssetOrderId:(NSString *)orderId
                     Password:(NSString *)password
                      Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock;
// 删除NH资产
+ (void)CCW_DeleteNHAssetId:(NSString *)nhAssetId
                     Password:(NSString *)password
                      Success:(SuccessBlock)successBlock
                        Error:(ErrorBlock)errorBlock;
// NH资产转移
+ (void)CCW_TransferNHAssetToAccount:(NSString *)to
                   NHAssetID:(NSString *)NHAssetID
                    Password:(NSString *)password
                     Success:(SuccessBlock)successBlock
                       Error:(ErrorBlock)errorBlock;
///**
// 升级成为终身会员账户
// @param isOnlyGetFee 是否获取手续费
// @param block 回调结果字典
// */
//+ (void)CCW_UpgradeAccount:(BOOL)isOnlyGetFee Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 订阅账户记录
//
// @param account 账号
// @param block 订阅结果
// */
//- (void)subscribeToAccountOperations:(NSString *)account Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
///**
// 资产创建
// @param assetId 资产符号
// @param maxSupply 最大资产总量
// @param precision 精度(小数位数)
// @param quoteAmount 手续费汇率:标价资产数量
// @param baseAmount 手续费汇率:基准资产数量
// @param description 描述
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)createAsset:(NSString *)assetId
//          maxSupply:(NSString *)maxSupply
//          precision:(NSString *)precision
//        quoteAmount:(NSString *)quoteAmount
//         baseAmount:(NSString *)baseAmount
//        description:(NSString *)description
//         onlyGetFee:(BOOL)onlyGetFee
//           Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 资产更新
// @param assetId 资产符号
// @param maxSupply 最大资产总量
// @param newIssuer 新发行人
// @param quoteAmount 手续费汇率:标价资产数量
// @param baseAmount 手续费汇率:基准资产数量
// @param description 描述
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)updateAsset:(NSString *)assetId
//          maxSupply:(NSString *)maxSupply
//          newIssuer:(NSString *)newIssuer
//        quoteAmount:(NSString *)quoteAmount
//         baseAmount:(NSString *)baseAmount
//        description:(NSString *)description
//         onlyGetFee:(BOOL)onlyGetFee
//           Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 资产发行
// @param toAccount 发行给
// @param amount 发行数量
// @param assetId 资产符号
// @param memo 备注消息
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)issueAsset:(NSString *)toAccount
//            amount:(NSString *)amount
//           assetId:(NSString *)assetId
//              memo:(NSString *)memo
//        onlyGetFee:(BOOL)onlyGetFee
//          Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 资产销毁
// @param assetId 资产符号
// @param amount 数量
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)reserveAsset:(NSString *)assetId
//              amount:(NSString *)amount
//          onlyGetFee:(BOOL)onlyGetFee
//            Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 注资资产手续费池
// @param assetId 资产符号
// @param amount 数量
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)assetFundFeePool:(NSString *)assetId
//                  amount:(NSString *)amount
//              onlyGetFee:(BOOL)onlyGetFee
//                Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 领取资产手续费
// @param assetId 资产符号
// @param amount 数量
// @param onlyGetFee 设置只返回本次调用所需手续费
// @param block 回调结果字典
// */
//- (void)assetClaimFees:(NSString *)assetId
//                amount:(NSString *)amount
//            onlyGetFee:(BOOL)onlyGetFee
//              Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 查询链上发行的资产
// @param symbol 资产
// @param block 回调结果字典
// */
//- (void)queryAssets:(NSString *)symbol
//           Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 注册开发者
// @param block 查询结果回调
// */
//- (void)registerCreator:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 创建世界观
// @param worldView 世界观
// @param block 查询结果回调
// */
//- (void)creatWorldView:(NSString *)worldView Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 提议关联世界观
// @param worldView 世界观
// @param block 查询结果回调
// */
//- (void)proposeRelateWorldView:(NSString *)worldView Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 获取当前用户收到的提议并审批
// @param account 帐号
// @param block 查询结果回调
// */
//- (void)getAccountProposals:(NSString *)account Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 创建NH资产
// @param assetId assetId
// @param block 查询结果回调
// */
//- (void)creatNHAsset:(NSString *)assetId
//           worldView:(NSString *)worldView
//        baseDescribe:(NSString *)baseDescribe
//        ownerAccount:(NSString *)ownerAccount
//       NHAssetsCount:(NSString *)NHAssetsCount
//                type:(NSString *)type
//            NHAssets:(NSString *)NHAssets
//      proposeAccount:(NSString *)proposeAccount
//            Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 删除NH资产
//
// @param NHAssetIds 唯一标识IDs,用逗号分割
// @param block 结果
// */
//- (void)deleteNHAsset:(NSString *)NHAssetIds Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
//
//
//
//
//
//
///**
// 注册账号
//
// @param userName 用户名
// @param pwd 密码
// @param block 回调结果字典
// */
//- (void)SignupWithName:(NSString *)userName pwd:(NSString *)pwd Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
//
//
//
//
//
///**
// 锁定账户
//
// @param block 回调结果
// */
//- (void)LockAccountWithResultCallback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 解锁账号
//
// @param password 密码
// @param block 回调结果
// */
//- (void)UnLockAccountByPassword:(NSString *)password Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 注册游戏开发者
//
// @param block 回调结果
// */
//- (void)RegisterGameDeveloperWithResultCallback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 创建游戏版本
//
// @param versionName 版本名称
// @param block 创建结果
// */
//- (void)CreateGameVersionWith:(NSString *)versionName Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 提议关联游戏版本
//
// @param gameVersion 游戏版本
// @param owner 游戏版本创建人
// @param block 结果回调
// */
//- (void)ProposeRelateGameVersionWith:(NSString *)gameVersion VersionOwner:(NSString *)owner Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 创建游戏道具
//
// @param assetId 资产id
// @param itemVer 道具版本itemVER
// @param itemData 道具数据data
// @param block 结果
// */
//- (void)CreateGameItemByAssetId:(NSString *)assetId
//                            VER:(NSString *)itemVer
//                           Data:(NSString *)itemData
//                       Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
//
//
//
//
///**
// 更新游戏道具数据
//
// @param itemID 游戏道具实例的唯一标识ID
// @param itemData 对道具新的描述itemData
// @param block 更新结果
// */
//- (void)UpdateGameItemBy:(NSString *)itemID Data:(NSString *)itemData Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
///**
// 查询道具详细信息
//
// @param gameHashOrID hash或道具id
// @param block 查询结果
// */
//- (void)QueryGameItemInfoBy:(NSString *)gameHashOrID Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 转移游戏道具
//
// @param account 转移目标账户
// @param itemID 道具ID
// @param block 转移结果
// */
//- (void)TransferGameItemToAccount:(NSString *)account ItemID:(NSString *)itemID ItemIDs:(NSString *)itemIDs Type:(NSString *)type Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 查询账户下所拥有的道具
//
// @param account 账户
// @param block 查询结果
// */
//- (void)QueryAccountGameItemsByAccount:(NSString *)account versions:(NSString *)versions pageSize:(NSString *)pageSize page:(NSString *)page Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
//
///**
// 创建游戏道具出售单
//
// @param account OTC交易平台账户otcAccount, 用于收取挂单费用
// @param itemID 道具itemID
// @param price 商品挂单价格price
// @param fee 挂单费用
// @param memo 挂单备注信息
// @param expiration 过期时间(即挂卖时间,number类型,如3600，表示3600秒后过期)
// @param priceAssetSymbol 商品挂单价格币种；（用户填写）
// */
//- (void)CreateGameItemOrderByOTCAccount:(NSString *)account
//                                 ItemID:(NSString *)itemID
//                                  Price:(NSString *)price
//                                    Fee:(NSString *)fee
//                                   Memo:(NSString *)memo
//                             Expiration:(NSInteger)expiration
//                       PriceAssetSymbol:(NSString *)priceAssetSymbol
//                               Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
///**
// 取消游戏道具出售单
//
// @param orderID 订单号
// @param block 取消结果回调
// */
//- (void)CancelGameItemOrderByOrderID:(NSString *)orderID Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
///**
// 装填游戏道具出售单
//
// @param orderID 订单ID
// @param block 操作结果
// */
//- (void)FillGameItemOrderByOrder:(NSString *)orderID
//                        Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 查询全网游戏道具售卖订单
//
// @param symbolsOrIds assetSymbolsOrIds
// @param versions versions
// @param pageSize 分页大小
// @param page 页码
// @param block 查询结果回调
// */
//- (void)QueryGameItemOrdersByAssetSymbolsOrIds:(NSString *)symbolsOrIds
//                                      versions:(NSString *)versions
//                                      PageSize:(NSInteger)pageSize
//                                          Page:(NSInteger)page
//                                      Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
///**
// 查询账户下游戏道具售卖订单
//
// @param account  账号
// @param pageSize 分页大小
// @param page 页码
// @param block 查询结果回调
// */
//- (void)QueryAccountGameItemOrdersByAccount:(NSString *)account PageSize:(NSInteger)pageSize Page:(NSInteger)page Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 查询游戏开发者所关联的游戏版本
//
// @param account 账号
// @param block 查询结果回调
// */
//- (void)QueryDeveloperGameVersionsByAccount:(NSString *)account Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
///**
// 查询游戏开发者所创建的道具
//
// @param account 账号
// @param block 查询结果回调
// */
//- (void)QueryGameItemByDeveloperByAccount:(NSString *)account Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
//
//
//
//
///**
// 查询block/TXID
//
// @param blockOrTXID 区块ID
// @param block 查询结果
// */
//- (void)QueryBlockTXID:(NSString *)blockOrTXID Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 查看当前登录账户收到的提议
//
// @param block 结果
// */
//- (void)GetAccountProposalsWithResult:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 加载节点投票信息数据
//
// @param block 数据返回
// */
//- (void)LoadVotesWithResult:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 代理投票账户
//
// @param voteIDs 节点数组 Array<NSString>
// @param account 代理投票账户
// @param block 结果
// */
//- (void)PublishVotesByVoteIds:(NSArray <NSString *>*)voteIDs ProxyAccount:(NSString *)account Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
///**
// 断开websoket通信
//
// @param voteIDs 节点数组 Array<NSString>
// @param account 代理投票账户
// @param block 结果
// */
//- (void)Disconnect:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 批准关联游戏版本的提议
// @param proposalId 提议Id
// @param block 结果回调
// */
//- (void)ApprovalProposal:(NSString *)proposalId Callback:(void(^)(NSDictionary *responseDict))block;
//
///**
// 监听与节点连接状态变化
// @param block 结果回调
// */
//- (void)SubscribeToRpcConnectionStatus: (void(^)(NSDictionary *responseDict))block;
//
//
///**
// 创建结构化数据
// @param data 提议Id
// @param block 结果回调
// */
//- (void)CreateStructData:(NSString *)data Callback:(void(^)(NSDictionary *responseDict))block;
//
//
///**
// 查询账户下的结构化数据
// @param account 账户
// @param page 页数
// @param pageSize 页容量
// @param block 结果回调
// */
//- (void)QueryStructData:(NSString *)account page:(NSString *)page pageSize:(NSString *)pageSize Callback:(void(^)(NSDictionary *responseDict))block;
//
//
//
@end

NS_ASSUME_NONNULL_END
