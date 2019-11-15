//
//  CCWTransRecordTableViewCell.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransRecordTableViewCell.h"

@interface CCWTransRecordTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *transferTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *transferAccountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation CCWTransRecordTableViewCell

/** 初始化Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier
{
    CCWTransRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCWTransRecordTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setTransRecordModel:(CCWTransRecordModel *)transRecordModel
{
    _transRecordModel = transRecordModel;
    CCWOperation *operation = transRecordModel.operation;
    if (transRecordModel.oprationType == CCWOpTypeTransition || transRecordModel.oprationType == CCWOpTypeNHTransfer) {
       
        // NH 资产
        if (transRecordModel.oprationType == CCWOpTypeNHTransfer) {
            if ([transRecordModel.from isEqualToString:CCWAccountName]) {
                self.transferAccountNameLabel.text = transRecordModel.to;
                self.transferTypeImageView.image = [UIImage imageNamed:@"transfer_out_nh"];
                self.transferCountLabel.textColor = [UIColor getColor:@"4868DC"];
            }else{
                self.transferAccountNameLabel.text = transRecordModel.from;
                self.transferTypeImageView.image = [UIImage imageNamed:@"transfer_in_nh"];
                self.transferCountLabel.textColor = [UIColor getColor:@"2FC49F"];
            }
            self.transferCountLabel.text = operation.nh_asset;
        }else{
            if ([transRecordModel.from isEqualToString:CCWAccountName]) {
                self.transferAccountNameLabel.text = transRecordModel.to;
                self.transferTypeImageView.image = [UIImage imageNamed:@"transfer_out"];
                self.transferCountLabel.textColor = [UIColor getColor:@"4868DC"];
                self.transferCountLabel.text = [NSString stringWithFormat:@"-%@ %@",operation.amount.amount,operation.amount.symbol];
            }else{
                self.transferAccountNameLabel.text = transRecordModel.from;
                self.transferTypeImageView.image = [UIImage imageNamed:@"transfer_in"];
                self.transferCountLabel.textColor = [UIColor getColor:@"2FC49F"];
                self.transferCountLabel.text = [NSString stringWithFormat:@"+%@ %@",operation.amount.amount,operation.amount.symbol];
            }
        }
        self.tipLabel.text = CCWLocalizable(CCWCoinTypeString);
    }else if (transRecordModel.oprationType == CCWOpTypeCallContract) {
        self.transferAccountNameLabel.text = transRecordModel.caller;
        self.transferTypeImageView.image = [UIImage imageNamed:@"trx_contract"];
        self.transferCountLabel.textColor = [UIColor getColor:@"4B4BD9"];
        self.transferCountLabel.text = transRecordModel.contractInfo.name;
        self.tipLabel.text = @"";
    }
    self.transferTimeLabel.text = transRecordModel.timestamp;
}
@end
