//
//  CCWRegisterTableViewCell.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/12/11.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWRegisterTableViewCell.h"

@interface CCWRegisterTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation CCWRegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.registerButton.layer.borderColor = [UIColor getColor:@"4E6ADC"].CGColor;
    self.registerButton.layer.borderWidth = 1;
    self.registerButton.layer.cornerRadius = 6;
    self.registerButton.layer.masksToBounds = YES;
    
}

/** 初始化Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier
{
    CCWRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCWRegisterTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
