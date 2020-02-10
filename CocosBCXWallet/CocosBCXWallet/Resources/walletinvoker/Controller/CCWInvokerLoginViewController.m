//
//  CCWInvokerLoginViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/1/8.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWInvokerLoginViewController.h"
#import "CocosWalletApi.h"
#import "CocosSwitchAccountView.h"

@interface CCWInvokerLoginViewController ()<CocosSwitchAccountViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIButton *switchAccount;

@property (nonatomic, strong) CocosSwitchAccountView *switchAccountView;


@property(nonatomic,copy)NSString *accountName;
@property(nonatomic,copy)NSString *accountID;

@end

@implementation CCWInvokerLoginViewController

- (CocosSwitchAccountView *)switchAccountView
{
    if (!_switchAccountView) {
        _switchAccountView = [CocosSwitchAccountView new];
        _switchAccountView.delegate = self;
    }
    return _switchAccountView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.switchAccount.layer.borderColor = [UIColor getColor:@"007AFF"].CGColor;
    self.switchAccount.layer.borderWidth = 1;
    
    self.nameLabel.text = self.loginModel.dappName;
    self.descLabel.text = self.loginModel.desc;
    [self.iconImageView CCW_SetImageWithURL:self.loginModel.dappIcon];
    
    
    CCWSETInvokerAccountName(CCWAccountName);
    CCWSETInvokerAccountId(CCWAccountId);
    self.accountLabel.text = CCWInvokerAccountName;
}

// 切换账户
- (IBAction)switchAccountClick:(UIButton *)sender {
    // 获取账户列表
    self.switchAccountView.dataSource = [CCWSDKRequest CCW_QueryAccountList];
    if (self.switchAccountView.isShow) {
        [self.switchAccountView Cocos_CloseCompletion:nil];
    }else{
        [self.switchAccountView Cocos_Show];
    }

}

- (void)Cocos_SwitchAccountView:(CocosSwitchAccountView *)switchAccountView didSelectDBAccountModel:(CocosDBAccountModel *)dbAccountModel
{
    CCWSETInvokerAccountId(dbAccountModel.ID);
    CCWSETInvokerAccountName(dbAccountModel.name);
    self.accountLabel.text = dbAccountModel.name;
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    CocosResponseObj *respons = [[CocosResponseObj alloc] init];
    respons.callbackSchema = self.loginModel.callbackSchema;
    respons.result = CocosRespResultSuccess;
    respons.action = self.loginModel.action;
    respons.data = @{
                     @"account_id":CCWInvokerAccountName?:@"",
                     @"account_name":CCWInvokerAccountId?:@""
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
