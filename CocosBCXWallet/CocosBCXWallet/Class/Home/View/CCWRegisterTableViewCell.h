//
//  CCWRegisterTableViewCell.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/12/11.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWRegisterTableViewCell : UITableViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
