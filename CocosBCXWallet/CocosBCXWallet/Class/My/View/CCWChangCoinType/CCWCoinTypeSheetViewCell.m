//
//  CCWCoinTypeSheetViewCell.m
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/28.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import "CCWCoinTypeSheetViewCell.h"

@interface CCWCoinTypeSheetViewCell()

@end
@implementation CCWCoinTypeSheetViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier
{
    CCWCoinTypeSheetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCWCoinTypeSheetViewCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
