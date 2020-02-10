//
//  CocosSwitchAccountCell.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocosSwitchAccountCell : UITableViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier;

/** <#视图#> */
@property (nonatomic, strong) CocosDBAccountModel *dbAccountModel;
@end

NS_ASSUME_NONNULL_END
