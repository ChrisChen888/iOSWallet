//
//  CCWTransferViewController.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/15.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWAssetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCWTransferViewController : CCWWalletBaseViewController
/** 资产模型 */
@property (nonatomic, strong) CCWAssetsModel *assetsModel;

/** 转账成功回调 */
@property (nonatomic, copy) void (^transferSuccess)();

@end

NS_ASSUME_NONNULL_END
