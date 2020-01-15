//
//  CCWOrderDetailViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/24.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWOrderDetailViewController.h"
#import "CCWCancelSellNHInfoView.h"
#import "CCWBuyNHInfoView.h"
#import "CCWPwdAlertView.h"

@interface CCWOrderDetailViewController ()<CCWCancelSellNHInfoViewDelegate,CCWBuyNHInfoViewDelegate>

// 渐变层
@property (weak, nonatomic) IBOutlet UIView *gradientView;

// 订单id
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *passAssetLabel;
@property (weak, nonatomic) IBOutlet UILabel *worldViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiratTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *baseDataLabel;

@property (weak, nonatomic) IBOutlet UIButton *optionButton;

/** 取消订单信息 */
@property (nonatomic, strong) CCWCancelSellNHInfoView *cancelOrderInfoView;
/** 购买订单信息 */
@property (nonatomic, strong) CCWBuyNHInfoView *bugNhInfoView;

@end

@implementation CCWOrderDetailViewController

- (CCWCancelSellNHInfoView *)cancelOrderInfoView
{
    if (!_cancelOrderInfoView) {
        _cancelOrderInfoView = [CCWCancelSellNHInfoView new];
        _cancelOrderInfoView.delegate = self;
    }
    return _cancelOrderInfoView;
}

- (CCWBuyNHInfoView *)bugNhInfoView
{
    if (!_bugNhInfoView) {
        _bugNhInfoView = [CCWBuyNHInfoView new];
        _bugNhInfoView.delegate = self;
    }
    return _bugNhInfoView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CCWLocalizable(@"订单详情");
    [self ccw_setNavBackgroundColor:[UIColor getColor:@"D2D9F3"]];
    self.gradientView.backgroundColor = [UIColor gradientColorFromColors:@[[UIColor getColor:@"D2D9F3"],[UIColor getColor:@"F6F7F8"]] gradientType:CCWGradientTypeTopToBottom colorSize:CGSizeMake(CCWScreenW, 280)];
    self.orderIDLabel.text = self.orderModel.ID;
    self.assetIDLabel.text = self.orderModel.nh_asset_id;
    self.worldViewLabel.text = self.orderModel.world_view;
    self.passAssetLabel.text = self.orderModel.asset_qualifier;
    self.noteLabel.text = self.orderModel.memo;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderModel.priceModel.amount,self.orderModel.priceModel.symbol];
    self.expiratTimeLabel.text = self.orderModel.expiration;
    self.baseDataLabel.text = [NSString stringWithFormat:@"%@",[self.orderModel.base_describe dictionaryValue]];
    self.sellerLabel.text = self.orderModel.seller;
    CCWWeakSelf
    [CCWSDKRequest CCW_QueryAccountInfo:self.orderModel.seller Success:^(id  _Nonnull responseObject) {
        weakSelf.sellerLabel.text = responseObject[@"name"];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        
    }];
    if (self.orderType == CCWNHAssetOrderTypeMy) {
        [self.optionButton setTitle:CCWLocalizable(@"取消") forState:UIControlStateNormal];
    }else{
        [self.optionButton setTitle:CCWLocalizable(@"购买") forState:UIControlStateNormal];
    }
}

- (IBAction)oprationClick:(UIButton *)sender {
    if (self.orderType == CCWNHAssetOrderTypeMy) {
        [self cancelNHAssetClick];
    }else{
        if ([self.orderModel.seller isEqualToString:CCWAccountId]) {
            [self.view makeToast:CCWLocalizable(@"不能购买自己创建的订单")];
            return;
        }
        [self buyNHAssetClick];
    }
}

- (IBAction)makeAccountCopy:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.sellerLabel.text];
    [self.view makeToast:CCWLocalizable(@"复制成功")];
}

#pragma mark - 取消订单
- (void)cancelNHAssetClick
{
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"取消订单"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单ID"),
                                       @"info":self.orderModel.ID,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":self.orderModel.nh_asset_id,
                                       }];
    [self CCW_CancelInfoViewShowWithArray:transferINfoArray];
}

- (void)CCW_CancelInfoViewShowWithArray:(NSArray *)array
{
    self.cancelOrderInfoView.dataSource = array;
    if (self.cancelOrderInfoView.isShow) {
        [self.cancelOrderInfoView CCW_CloseCompletion:nil];
    }else{
        [self.cancelOrderInfoView CCW_Show];
    }
}
- (void)CCW_CancelOrderInfoViewNextButtonClick:(CCWCancelSellNHInfoView *)transferInfoView
{
    // 输入密码
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        [weakSelf cancelBuyNHAssetWithPassword:pwd];
    }] show];
}

- (void)cancelBuyNHAssetWithPassword:(NSString *)password
{
    CCWWeakSelf
    [CCWSDKRequest CCW_CancelSellNHAssetOrderId:self.orderModel.ID Password:password Success:^(id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"取消成功")];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        !weakSelf.deleteComplete?:weakSelf.deleteComplete(weakSelf.orderType);
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if (error.code == 107){
            [weakSelf.view makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
        }if (error.code == 105){
            [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}

#pragma mark - 购买订单
- (void)buyNHAssetClick
{
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"购买资产"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单ID"),
                                       @"info":self.orderModel.ID,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":self.orderModel.nh_asset_id,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单价格"),
                                       @"info":[NSString stringWithFormat:@"%@ %@",self.orderModel.priceModel.amount,self.orderModel.priceModel.symbol],
                                       }];
    [self CCW_BuyInfoViewShowWithArray:transferINfoArray];
    
}

- (void)CCW_BuyInfoViewShowWithArray:(NSArray *)array
{
    self.bugNhInfoView.dataSource = array;
    if (self.bugNhInfoView.isShow) {
        [self.bugNhInfoView CCW_CloseCompletion:nil];
    }else{
        [self.bugNhInfoView CCW_Show];
    }
}

- (void)CCW_BuyInfoViewNextButtonClick:(CCWBuyNHInfoView *)transferInfoView
{
    // 输入密码
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        [weakSelf buyNHAssetWithPassword:pwd];
    }] show];
}

- (void)buyNHAssetWithPassword:(NSString *)password
{
    CCWWeakSelf
    [CCWSDKRequest CCW_BugNHAssetOrderId:self.orderModel.ID Password:password Success:^(id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"购买成功")];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        !weakSelf.deleteComplete?:weakSelf.deleteComplete(weakSelf.orderType);
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if (error.code == 107){
            [weakSelf.view makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
        }if (error.code == 105){
            [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}
@end
