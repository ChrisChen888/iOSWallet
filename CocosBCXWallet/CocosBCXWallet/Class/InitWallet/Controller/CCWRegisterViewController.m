//
//  CCWRegisterViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/4/9.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWRegisterViewController.h"
#import "CCWTipScreenShotViewController.h"
// 埋点统计
#import <UMAnalytics/MobClick.h>

@interface CCWRegisterViewController ()

/** 记录选择d按钮 */
@property (nonatomic, weak) UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *walletButton;

// 提示文字
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTipLabel;


// 注册控件
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@end

@implementation CCWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.accountButton setTitleColor:[UIColor getColor:@"A5A9B1"] forState:UIControlStateNormal];
    [self.accountButton setTitleColor:[UIColor getColor:@"262A33"] forState:UIControlStateSelected];
    [self.walletButton setTitleColor:[UIColor getColor:@"A5A9B1"] forState:UIControlStateNormal];
    [self.walletButton setTitleColor:[UIColor getColor:@"262A33"] forState:UIControlStateSelected];
    self.registerButton.backgroundColor = CCWButtonBgColor;
    [self.accountTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self accountOrWalletRegisterClick:self.accountButton];
}

- (IBAction)accountOrWalletRegisterClick:(UIButton *)sender {

    if (sender == self.selectButton) {
        return;
    }
    
    NSString *attributedText = @"";
    if (sender == self.accountButton) {
        attributedText = CCWLocalizable(@"账户模式下注册，可支持账号及私钥两种登录方式，请务必保管好账户信息及私钥，保护您的钱包安全");
    }else{
        attributedText = CCWLocalizable(@"钱包模式下注册，仅支持私钥登录，请务必备份好私钥，确保您的钱包安全。");
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedText length])];
    self.accountTipLabel.attributedText = attributedString;
    
    self.selectButton.selected = NO;
    sender.selected = YES;
    self.selectButton = sender;
}

-(void)textFieldTextChange:(UITextField *)textField{
    NSString *account = textField.text;
    if (![account ys_regexValidate:@"^[a-z][a-z0-9.-]{4,62}$"]) {
        self.remindLabel.text = CCWLocalizable(@"5-63位小写字母开头");
    }else{
        self.remindLabel.text = @"";
    }
}

/** 隐藏显示密码 */
- (IBAction)showOrHiddenClick:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.tag == 0) {
        if (sender.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.pwdTextField.text;
            self.pwdTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
            self.pwdTextField.secureTextEntry = NO;
            self.pwdTextField.text = tempPwdStr;
            
        } else { // 暗文
            NSString *tempPwdStr = self.pwdTextField.text;
            self.pwdTextField.text = @"";
            self.pwdTextField.secureTextEntry = YES;
            self.pwdTextField.text = tempPwdStr;
        }
    }else if (sender.tag == 1) {
        if (sender.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.confirmTextField.text;
            self.confirmTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
            self.confirmTextField.secureTextEntry = NO;
            self.confirmTextField.text = tempPwdStr;
            
        } else { // 暗文
            NSString *tempPwdStr = self.confirmTextField.text;
            self.confirmTextField.text = @"";
            self.confirmTextField.secureTextEntry = YES;
            self.confirmTextField.text = tempPwdStr;
        }

    }
}

// 注册
- (IBAction)CCW_Register {
    NSString *accountStr = self.accountTextField.text;
    NSString *pwdStr = self.pwdTextField.text;
    NSString *confirmStr = self.confirmTextField.text;
    [self.view endEditing:YES];
    
    if (IsStrEmpty(accountStr) || IsStrEmpty(pwdStr) ||IsStrEmpty(confirmStr)) {
        [self.view makeToast:CCWLocalizable(@"请输入账户信息")];
        return;
    }

    if (![accountStr ys_regexValidate:@"^[a-z][a-z0-9.-]{3,62}$"]) {
        [self.view makeToast:CCWLocalizable(@"账号名称不符合设置规则")];
        return;
    }

    // 不能含有空格
    NSRange pwdRange = [pwdStr rangeOfString:@" "];
    if (pwdRange.location != NSNotFound) {
        //有空格
        [self.view makeToast:CCWLocalizable(@"密码不能含有空格")];
        return;
    }
    
    // 密码规则
    if (![pwdStr ys_regexValidate:@"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*.]).{12,}$"]) {
        [self.view makeToast:CCWLocalizable(@"密码设置不符合规则")];
        return;
    }
    if (![pwdStr isEqualToString:confirmStr]) {
        [self.view makeToast:CCWLocalizable(@"前后密码设置不一致，请重新设置")];
        return;
    }
    
    CocosWalletMode walletMode = CocosWalletModeAccount;
    if (self.selectButton == self.walletButton) {
        walletMode = CocosWalletModeWallet;
    }
    
    CCWWeakSelf;
    [MBProgressHUD showLoadingMessage:nil];
    [CCWSDKRequest CCW_QueryAccountInfo:accountStr Success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.view makeToast:CCWLocalizable(@"账户已存在")];
    } Error:^(NSString * _Nonnull errorAlert, NSError * _Nonnull error) {
        if (error.code == 104) {
            [CCWSDKRequest CCW_CreateAccountWithWallet:accountStr password:pwdStr walletMode:walletMode autoLogin:YES Success:^(NSDictionary *responseObject) {
                [MBProgressHUD hideHUD];
                CCWSETAccountId(responseObject[@"id"]);
                CCWSETAccountName(responseObject[@"name"]);
                CCWTipScreenShotViewController *tipVC = [[CCWTipScreenShotViewController alloc] init];
                tipVC.account = responseObject;
                [weakSelf.navigationController pushViewController:tipVC animated:YES];
                [MobClick event:@"register" attributes:nil];
            } Error:^(NSString * _Nonnull errorAlert, NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [weakSelf.view makeToast:CCWLocalizable(errorAlert)];
            }];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}

@end
