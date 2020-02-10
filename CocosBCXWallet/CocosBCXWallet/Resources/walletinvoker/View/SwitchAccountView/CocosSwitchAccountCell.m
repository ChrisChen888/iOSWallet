//
//  CocosSwitchAccountCell.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CocosSwitchAccountCell.h"

@interface CocosSwitchAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *publicKeyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation CocosSwitchAccountCell

/** 初始化Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier
{
    CocosSwitchAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CocosSwitchAccountCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setDbAccountModel:(CocosDBAccountModel *)dbAccountModel
{
    _dbAccountModel = dbAccountModel;
    self.accountNameLabel.text = dbAccountModel.name;
    if ([dbAccountModel.name isEqualToString:CCWInvokerAccountName]) {
        self.selectImageView.hidden = NO;
    }else{
        self.selectImageView.hidden = YES;
    }
}

- (IBAction)makeAccountCopy:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.dbAccountModel.name];
    [CCWKeyWindow makeToast:CCWLocalizable(@"复制成功")];
}

@end
