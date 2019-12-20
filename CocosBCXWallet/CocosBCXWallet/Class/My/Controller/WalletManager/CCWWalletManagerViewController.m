//
//  CCWWalletManagerViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/19.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWWalletManagerViewController.h"
#import "CCWNavigationController.h"
#import "CCWExportViewController.h"
#import "CCWLogOutAlert.h"
#import "CCWFixPWDViewController.h"

@interface CCWWalletManagerViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicKeyLabel;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation CCWWalletManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self ccw_setNavBarTintColor:[UIColor whiteColor]];
    [self ccw_setNavBackgroundColor:[UIColor getColor:@"597DEF"]];
    [self ccw_setStatusBarStyle:UIStatusBarStyleLightContent];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ////////////// 渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, CCWScreenW, 116);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor getColor:@"597DEF"].CGColor,
                       (id)[UIColor getColor:@"FFFFFF"].CGColor, nil];
    [self.headerBackView.layer addSublayer:gradient];
    ////////////// 渐变色
    
    [self.headerView shadowWithColor:[UIColor getColor:@"EBEEF4"] offset:CGSizeMake(0, 4) opacity:1 radius:6];
    self.accountNameLabel.text = self.walletAccountModel.dbAccountModel.name;
    
    self.logoutButton.backgroundColor = CCWButtonBgColor;
    // 资产个数
    self.coinCountLabel.text = [CCWDecimalTool CCW_decimalSubScaleString:[NSString stringWithFormat:@"%@",self.walletAccountModel.cocosAssets.amount] scale:5];
    
    [self reloadPublicKey];
}

- (void)reloadPublicKey
{
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryAccountInfo:self.walletAccountModel.dbAccountModel.name Success:^(id  _Nonnull responseObject) {
        NSDictionary *activeDic = responseObject[@"active"];
        NSDictionary *ownerDic = responseObject[@"owner"];
        NSArray *activeKey = activeDic[@"key_auths"];
        NSArray *ownerKey = ownerDic[@"key_auths"];
        NSArray *activeKeyArray = [activeKey firstObject];
        NSArray *ownerKeyArray = [ownerKey firstObject];
        weakSelf.accountLabel.text = [activeKeyArray firstObject];
        weakSelf.publicKeyLabel.text = [ownerKeyArray firstObject];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

// 资产公钥
- (IBAction)makeActivePublicKey:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.accountLabel.text];
    [self.view makeToast:CCWLocalizable(@"复制成功")];
}

// 账户公钥
- (IBAction)makeOwnerPublicKey:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.publicKeyLabel.text];
    [self.view makeToast:CCWLocalizable(@"复制成功")];
}

// 修改密码
- (IBAction)fixPwdClick:(UIButton *)sender {
    CCWFixPWDViewController *fixPwdVC = [[CCWFixPWDViewController alloc] init];
    fixPwdVC.walletMode = self.walletAccountModel.dbAccountModel.walletMode;
    CCWWeakSelf;
    fixPwdVC.setpwdSuccess = ^{
        [weakSelf.view makeToast:CCWLocalizable(@"密码修改成功")];
        [weakSelf reloadPublicKey];
    };
    [self.navigationController pushViewController:fixPwdVC animated:YES];
}

// 导出私钥
- (IBAction)exportPrivitKeyClick:(UIButton *)sender {
    
    CCWWeakSelf
    CCWPasswordAlert(^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSString *password = [[alertVc textFields] objectAtIndex:0].text;
        [CCWSDKRequest CCW_GetPrivateKey:weakSelf.walletAccountModel.dbAccountModel.name password:password Success:^(id  _Nonnull responseObject) {
            NSString *activekey = responseObject[@"active_key"];
            NSString *ownerkey = responseObject[@"owner_key"];
            if (activekey == nil && ownerkey == nil) {
                [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
            }else{
                CCWExportViewController *exportVC = [[CCWExportViewController alloc] init];
                exportVC.keys = responseObject;
                [weakSelf.navigationController pushViewController:exportVC animated:YES];
            }
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            [weakSelf.view makeToast:CCWLocalizable(errorAlert)];
        }];
    });
}


// 退出登录
- (IBAction)loginPutClick:(UIButton *)sender {
    CCWWeakSelf;
    CCWLogOutAlert *visionAlret = [[CCWLogOutAlert alloc] init];
    CCWAlertAction *cancel = [CCWAlertAction CCW_actionWithTitle:CCWLocalizable(@"取消") style:CCWAlertActionStyleCancel handler:^(CCWAlertAction *action) {
        
    }];
    
    CCWAlertAction *comfirm = [CCWAlertAction CCW_actionWithTitle:CCWLocalizable(@"确认") style:CCWAlertActionStyleDefault handler:^(CCWAlertAction *action) {
        
        [CCWSDKRequest CCW_LogoutAccount:weakSelf.walletAccountModel.dbAccountModel.name Success:^(id  _Nonnull responseObject) {
            if ([weakSelf.walletAccountModel.dbAccountModel.name isEqualToString:CCWAccountName]) {
                NSArray *accountArray = [CCWSDKRequest CCW_QueryAccountList];
                if (accountArray.count > 0) {
                    CocosDBAccountModel *dbAccountModel = [accountArray firstObject];
                    CCWSETAccountName(dbAccountModel.name);
                    CCWSETAccountId(dbAccountModel.ID);
                    //                    CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    CCWSETAccountName(nil);
                    CCWSETAccountId(nil);
                    //                    id<CCWInitModuleProtocol> registerModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWInitModuleProtocol)];
                    //                    CCWNavigationController *registerController = [[CCWNavigationController alloc] initWithRootViewController:[registerModule CCW_LoginRegisterWalletViewController]];
                    //                    CCWKeyWindow.rootViewController = registerController;
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }else{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                //                CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
            }
            
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            [weakSelf.view makeToast:CCWLocalizable(@"退出账户失败")];
        }];
    }];
    [visionAlret alertWithRootViewControllerAddAction:@[cancel,comfirm]];
}

// 退出登录
//- (IBAction)loginPutClick:(UIButton *)sender {
//    CCWWeakSelf;
//    CCWLogOutAlert *visionAlret = [[CCWLogOutAlert alloc] init];
//    CCWAlertAction *cancel = [CCWAlertAction CCW_actionWithTitle:CCWLocalizable(@"取消") style:CCWAlertActionStyleCancel handler:^(CCWAlertAction *action) {
//
//    }];
//
//    CCWAlertAction *comfirm = [CCWAlertAction CCW_actionWithTitle:CCWLocalizable(@"确认") style:CCWAlertActionStyleDefault handler:^(CCWAlertAction *action) {
//
//        [CCWSDKRequest CCW_LogoutAccount:weakSelf.walletAccountModel.dbAccountModel.name Success:^(id  _Nonnull responseObject) {
//            if ([weakSelf.walletAccountModel.dbAccountModel.name isEqualToString:CCWAccountName]) {
//                NSArray *accountArray = [CCWSDKRequest CCW_QueryAccountList];
//                if (accountArray.count > 0) {
//                    CocosDBAccountModel *dbAccountModel = [accountArray firstObject];
//                    CCWSETAccountName(dbAccountModel.name);
//                    CCWSETAccountId(dbAccountModel.ID);
//                    CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
//                }else{
//                    CCWSETAccountName(nil);
//                    CCWSETAccountId(nil);
//                    id<CCWInitModuleProtocol> registerModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWInitModuleProtocol)];
//                    CCWNavigationController *registerController = [[CCWNavigationController alloc] initWithRootViewController:[registerModule CCW_LoginRegisterWalletViewController]];
//                    CCWKeyWindow.rootViewController = registerController;
//                }
//            }else{
//                CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
//            }
//
//        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
//            [weakSelf.view makeToast:CCWLocalizable(@"退出账户失败")];
//        }];
//    }];
//    [visionAlret alertWithRootViewControllerAddAction:@[cancel,comfirm]];
//}

@end
