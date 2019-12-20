//
//  CCWtransferRecordHeader.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransferRecordHeader.h"
#import "CCWAssetsModel.h"

@interface CCWTransferRecordHeader ()

@property (weak, nonatomic) IBOutlet UILabel *coinTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *titleHeaderView;

@end

@implementation CCWTransferRecordHeader

/** 初始化方法 */
+ (instancetype)transferRecordHeader
{
    CCWTransferRecordHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCWTransferRecordHeader class]) owner:self options:nil] lastObject];
    return headerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CCWScreenW, 47) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.titleHeaderView.layer.mask = maskLayer;
    
    self.addressLabel.text = CCWAccountName;
    
    self.backgroundColor = [UIColor gradientColorFromColors:@[[UIColor getColor:@"D2D9F3"],[UIColor getColor:@"F6F7F8"]] gradientType:CCWGradientTypeTopToBottom colorSize:CGSizeMake(CCWScreenW, self.height)];
}

- (void)setAssetsModel:(CCWAssetsModel *)assetsModel
{
    self.coinTitleLabel.text = assetsModel.symbol;
    self.countLabel.text = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",assetsModel.amount] scale:5];
    
    // COCOS显示金额
    if ([assetsModel.symbol isEqualToString:@"COCOS"]) {
        id cocosprice = [CCWSaveTool objectForKey:CCWCurrencyCocosPrice];
        NSString *totalPrice = [CCWDecimalTool CCW_multiplyTotalAssetsWithMultiplier:[NSString stringWithFormat:@"%@",cocosprice] faciend:[NSString stringWithFormat:@"%@",assetsModel.amount]].stringValue;
        NSString *price = [CCWDecimalTool CCW_convertRateWithPrice:totalPrice scale:6];
        
        // 测试网价格为0
        if (CCWNetNotesType) {
            self.priceLabel.text = [NSString stringWithFormat:@"≈%@%@",CCWCNYORUSD?@"￥":@"$",price];
        }else{
            self.priceLabel.text = [NSString stringWithFormat:@"≈%@0",CCWCNYORUSD?@"￥":@"$"];
        }
    }
}

- (IBAction)copyAddressButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(transferRecordHeaderCopyAddressClick:)]) {
        [self.delegate transferRecordHeaderCopyAddressClick:self];
    }
}

- (IBAction)transferButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(transferRecordHeaderTransferClick:)]) {
        [self.delegate transferRecordHeaderTransferClick:self];
    }
}

- (IBAction)receivButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(transferRecordHeaderReceivClick:)]) {
        [self.delegate transferRecordHeaderReceivClick:self];
    }
}
@end
