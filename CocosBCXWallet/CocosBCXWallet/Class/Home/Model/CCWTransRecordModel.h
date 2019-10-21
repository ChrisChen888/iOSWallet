//
//  CCWTransRecordModel.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/20.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// -----------------------------------------------------------------------------
typedef NS_ENUM(NSInteger, CCWOpType) {
    CCWOpTypeNoKnow = -1,          // 未做
    CCWOpTypeTransition = 0,          // 转账
    CCWOpTypeCallContract = 35,        // 合约
    CCWOpTypeNHTransfer = 42,        // NH资产转账
};

@interface CCWContractInfo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *creation_date;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *current_version;
@property (nonatomic, copy) NSString *contract_authority;
@property (nonatomic, copy) NSString *check_contract_authority;
@property (nonatomic, strong) NSArray *contract_data;
@property (nonatomic, strong) NSArray *contract_ABI;
@property (nonatomic, copy) NSString *lua_code_b_id;

@end

@interface CCWAmountFee : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, copy) NSString *asset_id;

// 辅助 //
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, strong) NSNumber *precision;

@end
@interface CCWMemo : NSObject

@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *message;

@end

@interface CCWOperation : NSObject

// 转账的操作
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, strong) CCWMemo *memo;

@property (nonatomic, strong) CCWAmountFee *amount;

// 合约交易
@property (nonatomic, copy) NSString *caller;
@property (nonatomic, copy) NSString *contract_id;
@property (nonatomic, copy) NSString *function_name;
@property (nonatomic, strong) NSArray *value_list;

// NH资产
@property (nonatomic, copy) NSString *nh_asset;
@end

@interface CCWTransRecordModel : NSObject

@property (nonatomic, strong) NSNumber *block_num;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSArray *op;

/// 辅助 ///转账
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;

/// 辅助 ///合约交易
@property (nonatomic, copy) NSString *caller;

// 合约信息
@property (nonatomic, strong) CCWContractInfo *contractInfo;

// 交易方式
@property (nonatomic, assign) CCWOpType oprationType;
@property (nonatomic, strong) CCWOperation *operation;

@property (nonatomic, strong) NSArray<CCWAmountFee *> *fees;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, strong) NSArray *result;


@end

NS_ASSUME_NONNULL_END
