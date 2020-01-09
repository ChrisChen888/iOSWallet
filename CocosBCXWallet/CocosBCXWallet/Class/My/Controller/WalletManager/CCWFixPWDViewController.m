//
//  CCWFixPWDViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/19.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWFixPWDViewController.h"

@interface CCWFixPWDViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pwdTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *currentPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nowPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *comlpleButton;

@end

@implementation CCWFixPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.walletMode == CocosWalletModeAccount) {
        self.title = CCWLocalizable(@"修改密码");
        self.pwdTipLabel.hidden = NO;
    }else{
        self.title = CCWLocalizable(@"重置密码");
        self.pwdTipLabel.hidden = YES;
    }
    self.comlpleButton.backgroundColor = CCWButtonBgColor;
    [self.nowPwdTextField addTarget:self action:@selector(textPwdChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textPwdChange:(UITextField *)textField
{
    if (self.walletMode == CocosWalletModeAccount) {
        self.pwdTipLabel.hidden = NO;
        if ([textField.text ys_regexValidate:@"^(?!^\\d+$)(?!^[A-Za-z]+$)(?!^[^A-Za-z0-9]+$)(?!^.*[\\u4E00-\\u9FA5].*$)^\\S{8,12}$"]) {
            self.pwdTipLabel.hidden = YES;
        }
    }
}


/** 隐藏显示密码 */
- (IBAction)showOrHiddenClick:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.tag == 0) {
        if (sender.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.currentPwdTextField.text;
            self.currentPwdTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
            self.currentPwdTextField.secureTextEntry = NO;
            self.currentPwdTextField.text = tempPwdStr;
            
        } else { // 暗文
            NSString *tempPwdStr = self.currentPwdTextField.text;
            self.currentPwdTextField.text = @"";
            self.currentPwdTextField.secureTextEntry = YES;
            self.currentPwdTextField.text = tempPwdStr;
        }
        
    }else if (sender.tag == 1) {
        if (sender.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.nowPwdTextField.text;
            self.nowPwdTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
            self.nowPwdTextField.secureTextEntry = NO;
            self.nowPwdTextField.text = tempPwdStr;
            
        } else { // 暗文
            NSString *tempPwdStr = self.nowPwdTextField.text;
            self.nowPwdTextField.text = @"";
            self.nowPwdTextField.secureTextEntry = YES;
            self.nowPwdTextField.text = tempPwdStr;
        }

    }else if (sender.tag == 2) {
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


- (IBAction)compleBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *currentPwdStr = self.currentPwdTextField.text;
    NSString *nowPwdStr = self.nowPwdTextField.text;
    NSString *confirmPwdStr = self.confirmTextField.text;
    
    if (IsStrEmpty(currentPwdStr) || IsStrEmpty(nowPwdStr) || IsStrEmpty(confirmPwdStr)) {
        [self.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
        return;
    }
    
    if (![nowPwdStr isEqualToString:confirmPwdStr]) {
        [self.view makeToast:CCWLocalizable(@"密码前后输入不一致，请重新输入")];
        return;
    }
    
    CCWWeakSelf
    if (self.walletMode == CocosWalletModeAccount) {
        if (![nowPwdStr ys_regexValidate:@"^(?!^\\d+$)(?!^[A-Za-z]+$)(?!^[^A-Za-z0-9]+$)(?!^.*[\\u4E00-\\u9FA5].*$)^\\S{8,12}$"]) {
            [self.view makeToast:CCWLocalizable(@"密码设置不符合规则，请重新输入")];
            return;
        }
        [CCWSDKRequest CCW_ChangePassword:currentPwdStr newPassword:nowPwdStr Success:^(id  _Nonnull responseObject) {
            !weakSelf.setpwdSuccess?:weakSelf.setpwdSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
            if (error.code == 105){
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else if ([error.userInfo[@"message"] containsString:@"Insufficient Balance"]) {
                [weakSelf.view makeToast:CCWLocalizable(@"余额不足")];
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
            }
        }];
    }else{
        [CCWSDKRequest CCW_ValidateAccount:CCWAccountName password:currentPwdStr Success:^(NSMutableDictionary *responseObject) {

            NSString *ownerPri = responseObject[@"owner_key"];
            NSString *activePri = responseObject[@"active_key"];
            if (ownerPri == nil && activePri == nil) {
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else{
                [CCWSDKRequest CCW_ReImportAccount:nowPwdStr OwnerPrivate:ownerPri ActivePrivate:activePri Success:^(id  _Nonnull responseObject) {
                    !weakSelf.setpwdSuccess?:weakSelf.setpwdSuccess();
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
                    [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
                }];
            }
        } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
            if (error.code == 105){
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
            }
        }];
    }
}


@end
