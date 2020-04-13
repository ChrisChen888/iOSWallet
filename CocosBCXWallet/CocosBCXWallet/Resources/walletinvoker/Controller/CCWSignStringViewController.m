//
//  CCWSignStringViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/4/13.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWSignStringViewController.h"
#import "CCWPwdAlertView.h"
#import "CCWSDKRequest.h"
#import "CocosWalletApi.h"

@interface CCWSignStringViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionLabel;
@end

@implementation CCWSignStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *dbAccount = [CCWSDKRequest CCW_QueryAccountList];
    
    CCWWeakSelf
    [dbAccount enumerateObjectsUsingBlock:^(CocosDBAccountModel *accountDB, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([accountDB.name isEqualToString:weakSelf.signStringObj.from]) {
            *stop = YES;
            return;
        }
        if (idx + 1 == dbAccount.count) {
            // 刷新
            CocosResponseObj *respons = [[CocosResponseObj alloc] init];
            respons.callbackSchema = weakSelf.signStringObj.callbackSchema;
            respons.result = CocosRespResultFailure;
            respons.action = weakSelf.signStringObj.action;
            respons.message = @" Authorized account doesn‘t exist, please re-authorize";
            [CocosWalletApi sendObj:respons];
        }
    }];
    self.nameLabel.text = self.signStringObj.dappName;
    self.descLabel.text = self.signStringObj.desc;
    [self.iconImageView CCW_SetImageWithURL:self.signStringObj.dappIcon];
    
    self.accountLabel.text = self.signStringObj.from;
}


- (IBAction)confirmButtonClick:(UIButton *)sender {
    
    CCWWeakSelf;
    CCWPwdAlertView *alert = [CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        // 加一层验证密码的
        [CCWSDKRequest CCW_ValidateAccount:self.signStringObj.from password:pwd Success:^(id  _Nonnull responseObject) {
            if (responseObject[@"active_key"]) {
                [CCWSDKRequest CCW_SignString:weakSelf.signStringObj.from Password:pwd string:weakSelf.signStringObj.signContent Success:^(id  _Nonnull responseObject) {
                    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
                    respons.callbackSchema = self.signStringObj.callbackSchema;
                    respons.result = CocosRespResultSuccess;
                    respons.action = self.signStringObj.action;
                    respons.data = responseObject;
                    respons.message = @"success";
                    [CocosWalletApi sendObj:respons];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
                    if (error.code == 116) {
                        [weakSelf.view makeToast:CCWLocalizable(@"签名账户不存在")];
                    }else if (error.code == 107){
                        [weakSelf.view makeToast:CCWLocalizable(@"请导入active key")];
                    }else if (error.code == 105){
                        [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
                    }else{
                        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
                    }
                }];
            }else if (responseObject[@"owner_key"]) {
                [weakSelf.view makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }
        } Error:^(NSString * _Nonnull errorAlert, NSError *error)  {
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
    }];
    [alert show];
}


- (IBAction)cancelButtonClick:(UIButton *)sender {
    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
    respons.callbackSchema = self.signStringObj.callbackSchema;
    respons.result = CocosRespResultCanceled;
    respons.action = self.signStringObj.action;
    respons.message = @"User rejected the signature request";
    [CocosWalletApi sendObj:respons];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
