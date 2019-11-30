//
//  CCWNodeInfoModel.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/6/3.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWNodeInfoModel : NSObject
@property (nonatomic, copy) NSString *chainId;
@property (nonatomic, copy) NSString *coreAsset;
@property (nonatomic, copy) NSString *faucetUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL type;
@property (nonatomic, copy) NSString *ws;
@property (nonatomic, assign) BOOL isForce;

// 是否是手动添加
@property (nonatomic, assign) BOOL isSelfSave;
@end

NS_ASSUME_NONNULL_END
