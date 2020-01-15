//
//  CCWTransferDetailViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransferDetailViewController.h"
#import "CCWAssetsModel.h"
#import "CCWPwdAlertView.h"

@interface CCWTransferDetailViewController ()
// 渐变层
@property (weak, nonatomic) IBOutlet UIView *gradientView;

// 转账成功title
@property (weak, nonatomic) IBOutlet UILabel *transferTypeLabel;
// 转账的b个数
@property (weak, nonatomic) IBOutlet UILabel *transferAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *outTitle;
@property (weak, nonatomic) IBOutlet UILabel *outAccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *inTitle;
@property (weak, nonatomic) IBOutlet UILabel *inAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *inAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitle;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UILabel *transferFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferHashLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferTimeLabel;

@end

@implementation CCWTransferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ccw_setNavBackgroundColor:[UIColor getColor:@"D2D9F3"]];
    self.gradientView.backgroundColor = [UIColor gradientColorFromColors:@[[UIColor getColor:@"D2D9F3"],[UIColor getColor:@"F6F7F8"]] gradientType:CCWGradientTypeTopToBottom colorSize:CGSizeMake(CCWScreenW, 280)];
    self.title = CCWLocalizable(@"交易详情");
    
    if (self.transRecordModel.oprationType == CCWOpTypeCallContract) { // 合约交易
        self.transferTypeLabel.text = CCWLocalizable(@"合约调用");;
        self.transferAccountLabel.text = self.transRecordModel.contractInfo.name;
        self.outTitle.text = CCWLocalizable(@"授权人:");
        self.outAccountLabel.text = CCWAccountName;
        self.inTitle.text = CCWLocalizable(@"动作:");
        self.inAccountLabel.text = self.transRecordModel.operation.function_name;
        self.inAccountButton.hidden = YES;
        self.remarkTitle.text = CCWLocalizable(@"数据:");
        
        // 寻找参数
        NSMutableArray *valueArray = [NSMutableArray array];
        for (NSArray *valueArr in self.transRecordModel.operation.value_list) {
            NSDictionary *value = [valueArr lastObject];
            [valueArray addObject:value[@"v"]];
        }
        // 寻找参数名
        NSArray *abiArray = self.transRecordModel.contractInfo.contract_ABI;
        for (NSArray *abi in abiArray) {
            NSDictionary *abiFunDic = [abi firstObject];
            NSArray *funkey = abiFunDic[@"key"];
            NSDictionary *funDic = [funkey lastObject];
            if ([funDic[@"v"] isEqualToString:self.transRecordModel.operation.function_name]) {
                NSDictionary *abiParamDic = [[abi lastObject] lastObject];
                NSArray *argArray = abiParamDic[@"arglist"];
                NSMutableString *paramStr = [NSMutableString string];
                [paramStr appendString:@"{"];
                for (int i = 0; i< argArray.count; i++) {
                    [paramStr appendString:@"\""];
                    [paramStr appendString:argArray[i]];
                    [paramStr appendString:@"\":\""];
                    [paramStr appendString:[NSString stringWithFormat:@"%@",valueArray[i]]];
                    [paramStr appendString:@"\""];
                    if (i < argArray.count - 1) {
                        [paramStr appendString:@","];
                    }
                }
                [paramStr appendString:@"}"];
                self.remarkLabel.text = paramStr;
                break;
            }
        }
    }else{
        
        if ([self.transRecordModel.from isEqualToString:CCWAccountName]) {
            self.transferAccountLabel.text = [NSString stringWithFormat:@"-%@ %@",self.transRecordModel.operation.amount.amount,self.transRecordModel.operation.amount.symbol];
        }else{
            self.transferAccountLabel.text = [NSString stringWithFormat:@"+%@ %@",self.transRecordModel.operation.amount.amount,self.transRecordModel.operation.amount.symbol];
        }
        self.outAccountLabel.text = self.transRecordModel.from;
        self.inAccountLabel.text = self.transRecordModel.to;
        
        // NH资产
        if (self.transRecordModel.oprationType == CCWOpTypeNHTransfer) {
            self.transferTypeLabel.text = CCWLocalizable(@"NH资产转移");;
            self.transferAccountLabel.hidden = YES;
            self.remarkTitle.text = CCWLocalizable(@"NH资产ID:");
            self.remarkLabel.text = self.transRecordModel.operation.nh_asset;
        }else{
            
            NSInteger memoType = [self.transRecordModel.operation.memo.firstObject integerValue];
            if (memoType == 0) {
                self.remarkLabel.text = self.transRecordModel.operation.memo.lastObject;
            }else{
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(decodeMemoTap:)];
                [self.remarkLabel addGestureRecognizer:tapGes];
                self.remarkLabel.text = CCWLocalizable(@"使用密码解锁备注");
                self.remarkLabel.textColor = [UIColor getColor:@"4868DC"];
            }
        }
    }
    CCWWeakSelf;
    CCWAmountFee *fee = nil;
    for (CCWAmountFee *assetModel in self.transRecordModel.fees) {
        if ([assetModel.asset_id isEqualToString:@"1.3.0"]) {
            fee = assetModel;
            break;
        }
    }
    if (fee) {
        [CCWSDKRequest CCW_QueryAssetInfo:fee.asset_id Success:^(CCWAssetsModel *assetsModel) {
            NSNumber *amount = [[CCWDecimalTool CCW_decimalNumberWithString:[NSString stringWithFormat:@"%@",fee.amount]] decimalNumberByMultiplyingByPowerOf10:-[assetsModel.precision integerValue]];
            weakSelf.transferFeeLabel.text = [NSString stringWithFormat:@"%@ %@",amount,assetsModel.symbol];;
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }];
    }else{
        self.transferFeeLabel.text = @"0 COCOS";
    }
    self.blockHeightLabel.text = [NSString stringWithFormat:@"%@",self.transRecordModel.block_num];
    self.transferTimeLabel.text = self.transRecordModel.timestamp;
    self.transferHashLabel.text = self.transRecordModel.ID;
}

- (void)decodeMemoTap:(UITapGestureRecognizer *)tapGesRecognizer
{
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        [CCWSDKRequest CCW_DecodeMemo:self.transRecordModel.operation.memo.lastObject Password:pwd Success:^(id  _Nonnull responseObject) {
            weakSelf.remarkLabel.userInteractionEnabled = NO;
            weakSelf.remarkLabel.text = responseObject;
            weakSelf.remarkLabel.textColor = [UIColor getColor:@"262A33"];
        } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
            if (error.code == 105){
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
            }
        }];
    }] show];
}

- (IBAction)makeAddress:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (sender.tag == 1) {
        [pasteboard setString:self.inAccountLabel.text];
    }else{
        [pasteboard setString:self.outAccountLabel.text];
    }
    [self.view makeToast:CCWLocalizable(@"复制成功")];
}

@end
