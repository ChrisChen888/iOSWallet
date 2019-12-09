//
//  CCWWalletTableViewCell.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/13.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWAssetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCWWalletTableViewCell : UITableViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier;

/** 资产模型 */
@property (nonatomic, strong) CCWAssetsModel *assetsModel;

@property (nonatomic, strong) CCWAssetsModel *receiveAssetsModel;
@end

NS_ASSUME_NONNULL_END
