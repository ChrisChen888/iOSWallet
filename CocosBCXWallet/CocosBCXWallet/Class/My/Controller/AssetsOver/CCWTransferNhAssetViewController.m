//
//  CCWTransferNhAssetViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/26.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWTransferNhAssetViewController.h"
#import "CCWAssetsModel.h"
#import "CCWBuyNHInfoView.h"

@interface CCWTransferNhAssetViewController ()<CCWBuyNHInfoViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *receiveTextField;
@property (weak, nonatomic) IBOutlet UITextField *nhAssetIDTextField;

/** 转账信息 */
@property (nonatomic, strong) CCWBuyNHInfoView *transferInfoView;

@end

@implementation CCWTransferNhAssetViewController

- (CCWBuyNHInfoView *)transferInfoView
{
    if (!_transferInfoView) {
        _transferInfoView = [CCWBuyNHInfoView new];
        _transferInfoView.delegate = self;
    }
    return _transferInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = CCWLocalizable(@"非同质资产转移");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scanQRCode"] style:UIBarButtonItemStylePlain target:self action:@selector(CCW_ScanQRCode)];
    self.nhAssetIDTextField.text = self.nhAssetModel.ID;
}

// 扫码二维码
- (void)CCW_ScanQRCode
{
    if ([CCWPrivacyPermissionsManager fxwIsOpenCamera]) {
        // 扫描二维码
        id<CCWMyModuleProtocol> myModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWMyModuleProtocol)];
        CCWWeakSelf
        UIViewController *scanQRCodeVC = [myModule CCW_ScanQRCodeToTransferWithBlock:^(NSDictionary *qrData) {
            weakSelf.receiveTextField.text = qrData[@"address"];
        }];
        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
    }else{
        [self.view makeToast:CCWLocalizable(@"请允许访问相机")];
    }
}

// 通讯录点击
- (IBAction)addressListClick:(UIButton *)sender {
    id<CCWMyModuleProtocol> myModuleProtocol = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWMyModuleProtocol)];
    CCWWeakSelf;
    UIViewController *viewController = [myModuleProtocol CCW_MyContactViewControllerWithBlock:^(NSString *address) {
        weakSelf.receiveTextField.text = address;
    }];
    [self.navigationController pushViewController:viewController animated:YES];
}

// 点击转账
- (IBAction)nextTransferClick:(UIButton *)sender {
    NSString *receiveAddress = self.receiveTextField.text;
    if (IsStrEmpty(receiveAddress)) {
        [self.view makeToast:CCWLocalizable(@"请输入资产接收方")];
        return;
    }
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"转移资产"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"转出账号"),
                                       @"info":CCWAccountName,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"转入账号"),
                                       @"info":receiveAddress,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":self.nhAssetModel.ID,
                                       }];
    [self CCW_TransferInfoViewShowWithArray:transferINfoArray];
}

- (void)CCW_TransferInfoViewShowWithArray:(NSArray *)array
{
    self.transferInfoView.dataSource = array;
    if (self.transferInfoView.isShow) {
        [self.transferInfoView CCW_Close];
    }else{
        [self.transferInfoView CCW_Show];
    }
}
- (void)CCW_BuyInfoViewNextButtonClick:(CCWBuyNHInfoView *)transferInfoView
{
    // 输入密码
    CCWWeakSelf
    CCWPasswordAlert(^(UIAlertAction * _Nonnull action) {
        // 通过数组拿到textTF的值
        NSString *password = [[alertVc textFields] objectAtIndex:0].text;
        [weakSelf transferNHAssetWithPassword:password];
    });
}

- (void)transferNHAssetWithPassword:(NSString *)password
{
    CCWWeakSelf
    [CCWSDKRequest CCW_TransferNHAssetToAccount:self.receiveTextField.text NHAssetID:self.nhAssetModel.ID Password:password Success:^(id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"转移成功")];
        // 改变Nav的栈
        NSArray *array = @[weakSelf.navigationController.viewControllers[0],weakSelf.navigationController.viewControllers[1], weakSelf];
        weakSelf.navigationController.viewControllers = array;
        [weakSelf.navigationController popViewControllerAnimated:YES];
        !weakSelf.transferNHAssetComplete?:weakSelf.transferNHAssetComplete();
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if (error.code == 104) {
            [weakSelf.view makeToast:CCWLocalizable(@"资产接收方不存在")];
        }else if (error.code == 116) {
            [weakSelf.view makeToast:CCWLocalizable(@"资产接收方不存在")];
        }else if (error.code == 107){
            [weakSelf.view makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
        }else if (error.code == 105){
            [weakSelf.view makeToast:CCWLocalizable(@"密码错误，请重新输入")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}
@end
