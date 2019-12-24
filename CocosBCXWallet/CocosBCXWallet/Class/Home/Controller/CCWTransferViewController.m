//
//  CCWTransferViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/15.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransferViewController.h"
#import "CCWTransferInfoView.h"

@interface CCWTransferViewController ()<UITextFieldDelegate,CCWTransferInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *receiveTextField;
@property (weak, nonatomic) IBOutlet UITextField *transferNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *remakeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;


/** 转账信息 */
@property (nonatomic, strong) CCWTransferInfoView *transferInfoView;

@end

@implementation CCWTransferViewController

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
     
    self.title = CCWLocalizable(@"转账");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scanQRCode"] style:UIBarButtonItemStylePlain target:self action:@selector(CCW_ScanQRCode)];
    NSString *balanceStr = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",self.assetsModel.availableTotal] scale:5];
    self.accountLabel.text = [NSString stringWithFormat:@"%@：%@ %@",CCWLocalizable(@"余额"),balanceStr,self.assetsModel.symbol];
    self.transferNumTextField.delegate = self;
    [self.transferNumTextField addTarget:self action:@selector(textEditingChange:) forControlEvents:UIControlEventEditingChanged];
}

// 扫码二维码
- (void)CCW_ScanQRCode
{
    if ([CCWPrivacyPermissionsManager fxwIsOpenCamera]) {
        // 扫描二维码
        id<CCWMyModuleProtocol> myModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWMyModuleProtocol)];
        CCWWeakSelf
        UIViewController *scanQRCodeVC = [myModule CCW_ScanQRCodeToTransferWithBlock:^(NSDictionary *qrData) {
            weakSelf.receiveTextField.text = qrData[@"address"];
            weakSelf.transferNumTextField.text = qrData[@"amount"];
        }];
        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
    }else{
        [self.view makeToast:CCWLocalizable(@"请允许访问相机")];
    }
}

// 通讯录点击
- (IBAction)addressListClick:(UIButton *)sender {
    id<CCWMyModuleProtocol> myModuleProtocol = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWMyModuleProtocol)];
    CCWWeakSelf;
    UIViewController *viewController = [myModuleProtocol CCW_MyContactViewControllerWithBlock:^(NSString *address) {
        weakSelf.receiveTextField.text = address;
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 转账全部资产
- (IBAction)transferAllAssets:(UIButton *)sender {
    self.transferNumTextField.text = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",self.assetsModel.availableTotal] scale:5];
}

// 点击转账
- (IBAction)nextTransferClick:(UIButton *)sender {
    
    NSString *receiveAddress = self.receiveTextField.text;
    NSString *transferNumStr = self.transferNumTextField.text;
    if (IsStrEmpty(receiveAddress)) {
        [self.view makeToast:CCWLocalizable(@"请输入转账信息")];
        return;
    }
    if ([receiveAddress isEqualToString:CCWAccountName]) {
        [self.view makeToast:CCWLocalizable(@"无法给自己转账")];
        return;
    }
    if (IsStrEmpty(transferNumStr)) {
        [self.view makeToast:CCWLocalizable(@"请输入转账数量")];
        return;
    }
    
    CCWWeakSelf
    [CCWSDKRequest CCW_QueryAccountInfo:receiveAddress Success:^(id  _Nonnull responseObject) {
        [weakSelf showTransferDetail];
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if (error.code == 104) {
            [weakSelf.view makeToast:CCWLocalizable(@"收款账户不存在")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}

- (void)showTransferDetail
{
    NSString *receiveAddress = self.receiveTextField.text;
    NSString *transferNumStr = self.transferNumTextField.text;
    
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"转账"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"转出账号"),
                                       @"info":CCWAccountName,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"转入账号"),
                                       @"info":receiveAddress,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"数量"),
                                       @"info":[NSString stringWithFormat:@"%@%@",transferNumStr,self.assetsModel.symbol],
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"备注"),
                                       @"info":self.remakeTextField.text,
                                       },];
    [self CCW_TransferInfoViewShowWithArray:transferINfoArray];
}

- (void)CCW_TransferInfoViewShowWithArray:(NSArray *)array
{
    self.transferInfoView.dataSource = array;
    if (self.transferInfoView.isShow) {
        [self.transferInfoView CCW_Close];
    }else{
        [self.transferInfoView CCW_Show];
    }
}

- (void)CCW_TransferInfoViewNextButtonClick:(CCWTransferInfoView *)transferInfoView
{
    NSString *receiveAddress = self.receiveTextField.text;
    NSString *transferNumStr = self.transferNumTextField.text;
    
    // 输入密码
    CCWWeakSelf
    CCWPasswordAlert(^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSString *password = [[alertVc textFields] objectAtIndex:0].text;
        [CCWSDKRequest CCW_TransferAsset:CCWAccountName toAccount:receiveAddress password:password assetId:self.assetsModel.asset_id amount:transferNumStr memo:self.remakeTextField.text Success:^(id  _Nonnull responseObject) {
            !weakSelf.transferSuccess?:weakSelf.transferSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
            if (error.code == 116) {
                [weakSelf.view makeToast:CCWLocalizable(@"收款账户不存在")];
            }else if (error.code == 107){
                [weakSelf.view makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
            }else if (error.code == 105){
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
            }
        }];
    });
}

#pragma mark - UITextField
- (void)textEditingChange:(UITextField *)textField
{
    if ([textField.text floatValue] > [self.assetsModel.availableTotal floatValue]) {
        NSString *balanceStr = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",self.assetsModel.availableTotal] scale:5];
        textField.text = balanceStr;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@".0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange) {
        //如果最先输入.，则在前面添加0
        if(self.transferNumTextField.text.length == 0 && [string isEqualToString:@"."]){
            self.transferNumTextField.text = @"0.";
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
            NSInteger iFive =  self.transferNumTextField.text.length - rangeTemp.location - rangeTemp.length - 4;
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

@end
