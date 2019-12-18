//
//  LYTAlertSheetTableViewCell.h
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/28.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCWCoinTypeSheetViewCell : UITableViewCell
/** 初始化方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle WithIdentifier:(NSString *)identifier;
@property (weak, nonatomic) IBOutlet UIImageView *coinTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
