//
//  CCWInvokerCallContractViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/1/10.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWInvokerCallContractViewController.h"
#import "CCWPwdAlertView.h"
#import "CCWSDKRequest.h"
#import "CocosWalletApi.h"

@interface CCWInvokerCallContractViewController ()

@end

@implementation CCWInvokerCallContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)confirmButtonClick:(UIButton *)sender {
    
    CCWWeakSelf;
    CCWPwdAlertView *alert = [CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        // 加一层验证密码的
        [CCWSDKRequest CCW_ValidateAccount:self.callContractModel.from password:pwd Success:^(id  _Nonnull responseObject) {
            if (responseObject[@"active_key"]) {
                
                [CCWSDKRequest CCW_CallContract:self.callContractModel.contract ContractMethodParam:self.callContractModel.param ContractMethod:self.callContractModel.method CallerAccount:self.callContractModel.from Password:pwd CallContractSuccess:^(id  _Nonnull responseObject) {
                   
                    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
                    respons.callbackSchema = self.callContractModel.callbackSchema;
                    respons.result = CocosRespResultSuccess;
                    respons.action = self.callContractModel.action;
                    respons.data = @{
                                     @"trx_id":responseObject,
                                     };
                    respons.message = @"success";
                    [CocosWalletApi sendObj:respons];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
    respons.callbackSchema = self.callContractModel.callbackSchema;
    respons.result = CocosRespResultCanceled;
    respons.action = self.callContractModel.action;
    respons.message = @"User rejected the signature request";
    [CocosWalletApi sendObj:respons];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
