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
#import "CocosCodeView.h"

@interface CCWInvokerCallContractViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionLabel;
@property (nonatomic, strong) CocosCodeView *codeView;

@end

@implementation CCWInvokerCallContractViewController

- (CocosCodeView *)codeView
{
    if (!_codeView) {
        _codeView = [CocosCodeView new];
    }
    return _codeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *dbAccount = [CCWSDKRequest CCW_QueryAccountList];
    
    CCWWeakSelf
    [dbAccount enumerateObjectsUsingBlock:^(CocosDBAccountModel *accountDB, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([accountDB.name isEqualToString:weakSelf.callContractModel.from]) {
            *stop = YES;
            return;
        }
        if (idx + 1 == dbAccount.count) {
            // 刷新
            CocosResponseObj *respons = [[CocosResponseObj alloc] init];
            respons.callbackSchema = weakSelf.callContractModel.callbackSchema;
            respons.result = CocosRespResultFailure;
            respons.action = weakSelf.callContractModel.action;
            respons.message = @" Authorized account doesn‘t exist, please re-authorize";
            [CocosWalletApi sendObj:respons];
        }
    }];
    
    self.nameLabel.text = self.callContractModel.dappName;
    self.descLabel.text = self.callContractModel.desc;
    [self.iconImageView CCW_SetImageWithURL:self.callContractModel.dappIcon];
    
    self.accountLabel.text = self.callContractModel.from;
    
    [self.actionLabel setTitle:[NSString stringWithFormat:@" %@->%@ ",self.callContractModel.contract,self.callContractModel.method] forState:UIControlStateNormal];
    [self.actionLabel sizeToFit];
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
                    respons.callbackSchema = weakSelf.callContractModel.callbackSchema;
                    respons.result = CocosRespResultSuccess;
                    respons.action = weakSelf.callContractModel.action;
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
                        CocosResponseObj *respons = [[CocosResponseObj alloc] init];
                        respons.callbackSchema = weakSelf.callContractModel.callbackSchema;
                        respons.result = CocosRespResultFailure;
                        respons.action = weakSelf.callContractModel.action;
                        respons.data = error.userInfo;
                        respons.message = @"error";
                        [CocosWalletApi sendObj:respons];
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)showDetailClick:(UIButton *)sender {
    CCWWeakSelf
    [CCWSDKRequest CCW_queryContra:self.callContractModel.contract Success:^(id  _Nonnull responseObject) {
        [CCWSDKRequest CCW_queryContractCreatInfo:responseObject[@"current_version"] Success:^(id  _Nonnull responseObject) {
            NSArray *operationsArray = responseObject[@"operations"];
            NSArray *dataArray = [operationsArray lastObject];
            NSDictionary *codeDictionaray = [dataArray lastObject];
            NSString *codeString = codeDictionaray[@"data"];
            NSLog(@"%@",codeDictionaray[@"data"]);
            
            // 获取账户列表
            weakSelf.codeView.codeString = codeString;
            if (weakSelf.codeView.isShow) {
                [weakSelf.codeView Cocos_CloseCompletion:nil];
            }else{
                [weakSelf.codeView Cocos_Show];
            }
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

@end
