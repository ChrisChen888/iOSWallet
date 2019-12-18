//
//  CCWWalletTableViewCell.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/13.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWWalletTableViewCell.h"

@interface CCWWalletTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coinImageView;
@property (weak, nonatomic) IBOutlet UILabel *coinNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CCWWalletTableViewCell

/** 初始化Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier
{
    CCWWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCWWalletTableViewCell class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setAssetsModel:(CCWAssetsModel *)assetsModel
{
    _assetsModel = assetsModel;
    self.accountLabel.text = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",assetsModel.amount] scale:[assetsModel.precision integerValue]];
    self.coinNameLabel.text = [NSString stringWithFormat:@"%@",assetsModel.symbol];

    NSString *price = @"0";
    if ([assetsModel.symbol isEqualToString:@"COCOS"]) {
        id cocosprice = [CCWSaveTool objectForKey:CCWCurrencyCocosPrice];
        price = [CCWDecimalTool CCW_convertRateWithPrice:[NSString stringWithFormat:@"%@",cocosprice] scale:6];
    }
    self.priceLabel.text = [NSString stringWithFormat:@"≈ %@%@",CCWCNYORUSD?@"￥":@"$",price];
}

- (void)setReceiveAssetsModel:(CCWAssetsModel *)receiveAssetsModel
{
    _receiveAssetsModel = receiveAssetsModel;
    self.accountLabel.hidden = YES;
    self.priceLabel.hidden = YES;
    self.coinNameLabel.text = [NSString stringWithFormat:@"%@",receiveAssetsModel.symbol];
}
@end
