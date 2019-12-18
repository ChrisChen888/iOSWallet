//
//  CCWImportViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWImportViewController.h"

@interface CCWImportViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *privateTextView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *importButton;

@end

@implementation CCWImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CCWLocalizable(@"导入钱包");
    self.importButton.backgroundColor = CCWButtonBgColor;
    [self.backView cornerRadius:6.0 strokeWidth:0.5 color:[UIColor getColor:@"D8DBE1"]];
    self.privateTextView.placeHoldString = CCWLocalizable(@"请输入明文私钥");
    self.privateTextView.placeHoldColor = [UIColor getColor:@"A5A9B1"];
    self.privateTextView.placeHoldFont = CCWFont(14);
    [self.pwdTextField setValue:[UIColor getColor:@"A5A9B1"] forKeyPath:@"_placeholderLabel.textColor"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CCWLocalizable(@"登录") style:UIBarButtonItemStylePlain target:self action:@selector(loginClick)];
}

// 注册
- (void)loginClick
{
    [self.navigationController pushViewController:[NSClassFromString(@"CCWLoginViewController") new] animated:YES];
}
- (IBAction)importClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *privateKeyStr = self.privateTextView.text;
    NSString *pwdStr = self.pwdTextField.text;
    if (IsStrEmpty(privateKeyStr)) {
        [self.view makeToast:CCWLocalizable(@"请输入私钥")];
        return;
    }
    if (IsStrEmpty(pwdStr)) {
        [self.view makeToast:CCWLocalizable(@"请设置临时密码")];
        return;
    }
    CCWWeakSelf
    [MBProgressHUD showLoadingMessage:nil];
    // 网络失败，3秒消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    [CCWSDKRequest CCW_PrivateKeyLogin:privateKeyStr password:pwdStr Success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        CCWSETAccountName(responseObject[@"account"]);
        CCWSETAccountId(responseObject[@"id"]);
        [weakSelf.view makeToast:CCWLocalizable(@"导入成功")];
        CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
    } Error:^(NSString * _Nonnull errorAlert, NSError *  _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (error.code == 109 || error.code == 110) {
            [weakSelf.view makeToast:CCWLocalizable(@"私钥无效，请重新输入")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}

@end
