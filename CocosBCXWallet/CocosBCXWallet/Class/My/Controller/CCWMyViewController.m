//
//  CCWMyViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/1/29.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWMyViewController.h"

@interface CCWMyViewController ()

@end

@implementation CCWMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccw_setNavBackgroundColor:[UIColor getColor:@"f6f7f8"]];
}

- (IBAction)myViewdidSelectIndexPath:(UIButton *)button
{
    NSInteger tagInteger = button.tag;
    switch (tagInteger) {
        case 0:
            
            if (!CCWAccountId) {
                [self.view makeToast:CCWLocalizable(@"请登陆/注册后再试")];
                return;
            }
            [self.navigationController pushViewController:[NSClassFromString(@"CCWAssetsOverviewViewController") new] animated:YES];
            break;
        case 1: // 钱包管理
            [self.navigationController pushViewController:[NSClassFromString(@"CCWWalletListViewController") new] animated:YES];
            break;
        case 2:// 系统设置
            [self.navigationController pushViewController:[NSClassFromString(@"CCWSystemSetViewController") new] animated:YES];
            break;
        case 3:// 联系人
            [self.navigationController pushViewController:[NSClassFromString(@"CCWContactViewController") new] animated:YES];
            break;
        case 4:// 关于我们
            [self.navigationController pushViewController:[NSClassFromString(@"CCWAboutUsViewController") new] animated:YES];
            break;
        default:
            break;
    }
}

@end
