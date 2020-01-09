//
//  CCWRegisterViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWLoginViewController.h"
#import "CCWCheckVisionAlert.h"
#import "YBPopupMenu.h"
#import "CCWDataBase+CCWNodeINfo.h"

@interface CCWLoginViewController ()<YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *switchNetButton;
// 登录控件
@property (weak, nonatomic) IBOutlet UITextField *loginAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginPwdTextField;

/** 节点 */
@property (nonatomic, strong) NSMutableArray *nodeInfoArray;
/** 当前节点 */
@property (nonatomic, strong) CCWNodeInfoModel *currentNodeInfo;
@end

@implementation CCWLoginViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.switchNetButton.layer.borderWidth = 0.5;
    self.switchNetButton.layer.borderColor = [UIColor getColor:@"DCDCDC"].CGColor;
    
    
    self.loginButton.backgroundColor = CCWButtonBgColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CCWLocalizable(@"注册") style:UIBarButtonItemStylePlain target:self action:@selector(registerClick)];
    
    [self CCW_RequestAPPVersionInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"CCWNetConnectNetworkKey" object:nil];
    [self connectSuccess];
}

- (void)connectSuccess
{
    CCWNodeInfoModel *currentNodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
    [self.switchNetButton setTitle:currentNodeInfo.name forState:UIControlStateNormal];
}


/** 隐藏显示密码 */
- (IBAction)showOrHiddenClick:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.loginPwdTextField.text;
        self.loginPwdTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.loginPwdTextField.secureTextEntry = NO;
        self.loginPwdTextField.text = tempPwdStr;
        
    } else { // 暗文
        NSString *tempPwdStr = self.loginPwdTextField.text;
        self.loginPwdTextField.text = @"";
        self.loginPwdTextField.secureTextEntry = YES;
        self.loginPwdTextField.text = tempPwdStr;
    }
}

- (IBAction)switchNodeInfoClick:(UIButton *)sender {
    
    self.nodeInfoArray = [[CCWDataBase CCW_shareDatabase] CCW_QueryNodeInfo];

    [YBPopupMenu showRelyOnView:sender titles:self.nodeInfoArray icons:nil menuWidth:74 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.delegate = self;
        popupMenu.arrowWidth = 0;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    CCWNodeInfoModel *nodeInfo = self.nodeInfoArray[index];
    // 最新新节点
    CCWWeakSelf;
    [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
        
        // 查询节点的chainid 是否相等
        [CCWSDKRequest CCW_QueryCurrentChainID:^(id  _Nonnull responseObject) {
            if ([nodeInfo.chainId isEqualToString:responseObject]) {
                // 节点类型
                CCWNetNotesType = nodeInfo.type;
                [weakSelf.switchNetButton setTitle:nodeInfo.name forState:UIControlStateNormal];
                // 记录已连接的数据
                CCWSETNodeInfo([nodeInfo mj_keyValues]);
                
                // 判断当前链是否已经有账户
                NSArray *accountArray = [CCWSDKRequest CCW_QueryAccountList];
                if (accountArray.count > 0) {
                    CocosDBAccountModel *dbAccountModel = [accountArray firstObject];
                    CCWSETAccountName(dbAccountModel.name);
                    CCWSETAccountId(dbAccountModel.ID);
                    // 发个通知
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
//                    });
                }else{
                    CCWSETAccountName(nil);
                    CCWSETAccountId(nil);
                }
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"切换失败")];
                CCWNodeInfoModel *nodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
                // 最新新节点
                [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
                    // 发个通知
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
//                    });
                } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
                    
                }];
            }
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            
        }];
        
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"切换失败")];
        CCWNodeInfoModel *nodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
        // 最新新节点
        [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
            // 发个通知
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
//            });
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            
        }];
    }];
}

/**
 自定义cell
 
 可以自定义cell，设置后会忽略 fontSize textColor backColor type 属性
 cell 的高度是根据 itemHeight 的，直接设置无效
 建议cell 背景色设置为透明色，不然切的圆角显示不出来
 */
- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    CCWNodeInfoModel *currentNodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
    CCWNodeInfoModel *nodeInfo = self.nodeInfoArray[index];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"testCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = nodeInfo.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor getColor:@"666666"];
    if ([currentNodeInfo.ws isEqualToString:nodeInfo.ws] && [currentNodeInfo.chainId isEqualToString:nodeInfo.chainId] && [currentNodeInfo.faucetUrl isEqualToString:nodeInfo.faucetUrl] && [currentNodeInfo.coreAsset isEqualToString:nodeInfo.coreAsset]) {
        cell.textLabel.textColor = [UIColor getColor:@"4C6ADD"];
    }
    return cell;
}

// 获取版本信息
- (void)CCW_RequestAPPVersionInfo
{
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryVersionInfoSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *dataDic = responseObject[@"data"];
        NSString *version = dataDic[@"version"];
        NSString *current = AppVersionNumber;
        //        TWLog(@"线上版本：%@----本地版本：%@",version,current);
        // 判断 version > current ？
        int result = [version compare:current options:NSCaseInsensitiveSearch | NSNumericSearch];
        if (result == 1){ // 有更新
            CCWIsHaveUpdate = YES;
            CCWIsForceUpdate = [dataDic[@"is_force"] boolValue];
            CCWAppNewVersion = version;
            CCWNewAppDownloadurl = dataDic[@"download_url"];
            CCWNewAppUpdateNotes = dataDic[@"info"];
            CCWNewAppUpdateEnNotes = dataDic[@"en_info"];
            // 更新
            [[CCWCheckVisionAlert new] alertWithRootViewController];
        }
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

// 注册
- (void)registerClick
{
    [self.navigationController pushViewController:[NSClassFromString(@"CCWRegisterViewController") new] animated:YES];
}

// 登录
- (IBAction)loginButtonClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *accountStr = self.loginAccountTextField.text;
    NSString *pwdStr = self.loginPwdTextField.text;
    if (IsStrEmpty(accountStr) || IsStrEmpty(pwdStr)) {
        [self.view makeToast:CCWLocalizable(@"请输入账户信息")];
        return;
    }
    
    [MBProgressHUD showLoadingMessage:nil];
    CCWWeakSelf
    [CCWSDKRequest CCW_PasswordLogin:accountStr password:pwdStr Success:^(id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        CCWSETAccountName(responseObject[@"account"]);
        CCWSETAccountId(responseObject[@"id"]);
        
        CCWKeyWindow.rootViewController = [NSClassFromString(@"CCWTabViewController") new];
    } Error:^(NSString * _Nonnull errorAlert, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (error.code == 108 || error.code == 105) {
            [weakSelf.view makeToast:CCWLocalizable(@"请输入正确的账户名称或者密码")];
        }else{
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
}

- (IBAction)importButtonClick:(UIButton *)sender {
    
    [self.navigationController pushViewController:[NSClassFromString(@"CCWImportViewController") new] animated:YES];
}
    
@end
