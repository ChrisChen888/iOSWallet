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

@property (weak, nonatomic) IBOutlet UILabel *havelockCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockAmontLabel;


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
    
    if (assetsModel.locked_total.doubleValue == 0) { // 没有锁仓金额
        self.havelockCoinLabel.hidden = YES;
        self.lockAmontLabel.hidden = YES;
        self.coinNameLabel.hidden = NO;
        self.coinNameLabel.text = [NSString stringWithFormat:@"%@",assetsModel.symbol];
    }else {
        self.havelockCoinLabel.hidden = NO;
        self.lockAmontLabel.hidden = NO;
        self.coinNameLabel.hidden = YES;
        self.havelockCoinLabel.text = [NSString stringWithFormat:@"%@",assetsModel.symbol];
        self.lockAmontLabel.text = [NSString stringWithFormat:@"%@ %@",CCWLocalizable(@"冻结"),[CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",assetsModel.locked_total] scale:[assetsModel.precision integerValue]]];
    }
    
    self.accountLabel.text = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",assetsModel.availableTotal] scale:[assetsModel.precision integerValue]];
    
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
    self.havelockCoinLabel.hidden = YES;
    self.lockAmontLabel.hidden = YES;
    self.accountLabel.hidden = YES;
    self.priceLabel.hidden = YES;
    self.coinNameLabel.text = [NSString stringWithFormat:@"%@",receiveAssetsModel.symbol];
}
@end
