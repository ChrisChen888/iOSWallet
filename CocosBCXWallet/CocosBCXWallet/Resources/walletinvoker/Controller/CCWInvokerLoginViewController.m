//
//  CCWInvokerLoginViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/1/8.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWInvokerLoginViewController.h"
#import "CocosWalletApi.h"

@interface CCWInvokerLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIButton *switchAccount;

@end

@implementation CCWInvokerLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.switchAccount.layer.borderColor = [UIColor getColor:@"007AFF"].CGColor;
    self.switchAccount.layer.borderWidth = 1;
    
    self.nameLabel.text = self.loginModel.dappName;
    self.descLabel.text = self.loginModel.desc;
    [self.iconImageView CCW_SetImageWithURL:self.loginModel.dappIcon];
    
    self.accountLabel.text = CCWAccountName;
}

// 切换账户
- (IBAction)switchAccountClick:(UIButton *)sender {

}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
    respons.callbackSchema = self.loginModel.callbackSchema;
    respons.result = CocosRespResultSuccess;
    respons.action = self.loginModel.action;
    respons.data = @{
                     @"account_id":CCWAccountId?:@"",
                     @"account_name":CCWAccountName?:@""
                     };
    respons.message = @"success";
    [CocosWalletApi sendObj:respons];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
    respons.callbackSchema = self.loginModel.callbackSchema;
    respons.result = CocosRespResultCanceled;
    respons.action = self.loginModel.action;
    respons.message = @"User rejected the Login request";
    [CocosWalletApi sendObj:respons];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
