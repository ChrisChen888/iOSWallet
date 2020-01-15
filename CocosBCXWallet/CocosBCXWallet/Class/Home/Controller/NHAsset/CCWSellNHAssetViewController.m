//
//  CCWSellNHAssetViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/24.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWSellNHAssetViewController.h"
#import "CCWSelectSellCoinViewController.h"
#import "CCWTransferInfoView.h"
#import "CCWPwdAlertView.h"

@interface CCWSellNHAssetViewController ()<UITextFieldDelegate,UIScrollViewDelegate,CCWTransferInfoViewDelegate>
{
    NSString *password_;
}
@property (nonatomic, weak) IBOutlet UITextField *nhAssetIDTF;
@property (nonatomic, weak) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (nonatomic, weak) IBOutlet UITextField *validTimeTF;
@property (nonatomic, weak) IBOutlet UITextField *noteTF;
// 最大时间
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel;
// 价格模型
@property (nonatomic, strong) CCWAssetsModel *priceModel;

/** 转账信息 */
@property (nonatomic, strong) CCWTransferInfoView *transferInfoView;

/** 最大时间 */
@property (nonatomic, assign) int nhAssetOrderExpiration;
@end

@implementation CCWSellNHAssetViewController

- (CCWTransferInfoView *)transferInfoView
{
    if (!_transferInfoView) {
        _transferInfoView = [CCWTransferInfoView new];
        _transferInfoView.delegate = self;
    }
    return _transferInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CCWLocalizable(@"非同质资产出售");
    self.nhAssetIDTF.text = self.nhAssetModel.ID;
    self.priceModel = [[CCWAssetsModel alloc] init];
    self.priceModel.symbol = @"COCOS";
    self.priceModel.ID = @"1.3.0";
    [self.coinButton setTitle:self.priceModel.symbol forState:UIControlStateNormal];
    
    CCWWeakSelf;
    [CCWSDKRequest CCW_SellNHAssetMaxExpirationSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *parameters = responseObject[@"parameters"];
        NSNumber *orderExpirationNumber = parameters[@"maximum_nh_asset_order_expiration"];
        weakSelf.nhAssetOrderExpiration = [orderExpirationNumber intValue] - 100;
        weakSelf.maxTimeLabel.text = [NSString stringWithFormat:@"%@：%i",CCWLocalizable(@"最大时间"),weakSelf.nhAssetOrderExpiration];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

// 选择币种
- (IBAction)selectCoinClick:(UIButton *)sender {
    CCWSelectSellCoinViewController *selectCoinVC = [[CCWSelectSellCoinViewController alloc] init];
    selectCoinVC.selectAssetModel = self.priceModel;
    CCWWeakSelf;
    selectCoinVC.selectBlock = ^(CCWAssetsModel * _Nonnull selectAssetModel) {
        weakSelf.priceModel = selectAssetModel;
        [weakSelf.coinButton setTitle:weakSelf.priceModel.symbol forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:selectCoinVC animated:YES];
}

- (IBAction)sellNHAssetClick
{
    NSString *price = self.priceTF.text;
    NSString *validTime = self.validTimeTF.text;
    if (IsStrEmpty(price)) {
        [self.view makeToast:CCWLocalizable(@"请输入挂单价格")];
        return;
    }
    if (IsStrEmpty(validTime)) {
        [self.view makeToast:CCWLocalizable(@"请输入挂单有效时间")];
        return;
    }else if([validTime intValue] > self.nhAssetOrderExpiration){
        validTime = [NSString stringWithFormat:@"%i",self.nhAssetOrderExpiration];
        self.validTimeTF.text = validTime;
    }
    
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"出售资产"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":self.nhAssetModel.ID,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"价格"),
                                       @"info":[NSString stringWithFormat:@"%@ %@",price,self.priceModel.symbol],
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"有效时间"),
                                       @"info":[NSString stringWithFormat:@"%@ s",validTime],
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"备注"),
                                       @"info":self.noteTF.text,
                                       }];
    [self CCW_TransferInfoViewShowWithArray:transferINfoArray];
}

- (void)CCW_TransferInfoViewShowWithArray:(NSArray *)array
{
    self.transferInfoView.dataSource = array;
    if (self.transferInfoView.isShow) {
        [self.transferInfoView CCW_CloseCompletion:nil];
    }else{
        [self.transferInfoView CCW_Show];
    }
}

- (void)CCW_TransferInfoViewNextButtonClick:(CCWTransferInfoView *)transferInfoView
{
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        [weakSelf sellNHAssetWithPassword:pwd];
    }] show];
}

- (void)sellNHAssetWithPassword:(NSString *)password
{
    NSString *price = self.priceTF.text;
    NSString *validTime = self.validTimeTF.text;
    CCWWeakSelf
    [CCWSDKRequest CCW_SellNHAssetNHAssetId:self.nhAssetModel.ID Password:password Memo:self.noteTF.text SellPriceAmount:price SellAsset:self.priceModel.ID Expiration:validTime Success:^(id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"挂单成功")];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        !weakSelf.sellSuccess?:weakSelf.sellSuccess();
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

#pragma mark - UITextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange) {
        //如果最先输入.，则在前面添加0
        if(self.priceTF.text.length == 0 && [string isEqualToString:@"."]){
            self.priceTF.text = @"0.";
            return NO;
        }
        NSRange rangeTemp = [textField.text rangeOfString:@"."];
        if ([string isEqualToString:@"."]) {
            //不允许重复输入.
            if (rangeTemp.length > 0 ) {
                return NO;
            }
        }
        
        //小数点后保持后5位
        if (rangeTemp.length > 0) {
            NSInteger iFive =  self.priceTF.text.length - rangeTemp.location - rangeTemp.length - 4;
            if (iFive > 0 ) {
                if ([string isEqualToString:@""]) {
                    return YES;
                }else
                    return NO;
            }
        }
    }
    return canChange;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end
