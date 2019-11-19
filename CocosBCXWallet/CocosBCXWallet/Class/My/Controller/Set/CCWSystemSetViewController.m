//
//  CCWSystemSetViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/19.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSystemSetViewController.h"

#import "CCWTabViewController.h"
#import "CCWMyAlertSheetView.h"
#import "CCWNodeAlertSheetView.h"
#import "CCWDataBase+CCWNodeINfo.h"
#import "CCWAddNodeViewController.h"
#import "CCWNavigationController.h"

@interface CCWSystemSetViewController ()<CCWMyAlertSheetViewDelegate,CCWNodeAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *netLabel;
@property (nonatomic, strong) NSMutableArray *nodeInfoArray;
@end

@implementation CCWSystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CCWLocalizable(@"系统设置");
    self.currentLanguageLabel.text = [CCWLocalizableTool userLanguageString];
    
    CCWNodeInfoModel *nodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
    self.netLabel.text = nodeInfo.type?CCWLocalizable(@"主网"):CCWLocalizable(@"测试网");
}

- (IBAction)CCW_SetViewdidSelectIndexPath:(UIButton *)button
{
    NSInteger tagInteger = button.tag;
    switch (tagInteger) {
        case 0:
        {
            CCWMyAlertSheetView *alertSheetView = [[CCWMyAlertSheetView alloc] init];
            alertSheetView.delegate = self;
            [alertSheetView CCW_Show];
        }
            break;
        case 1:
        {
            CCWNodeAlertSheetView *nodeSheetView = [[CCWNodeAlertSheetView alloc] init];
            nodeSheetView.delegate = self;
            self.nodeInfoArray = [[CCWDataBase CCW_shareDatabase] CCW_QueryNodeInfo];
            [nodeSheetView CCW_ShowWithDataArray:self.nodeInfoArray];
        }
            break;
        default:
            break;
    }
}

- (void)CCW_NodeAlertCellDeleteNodel:(id)alertCell nodeArray:(NSMutableArray *)nodeArray
{
    self.nodeInfoArray = nodeArray;
}

- (void)CCW_MyAlertSheetView:(CCWMyAlertSheetView *)alertSheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWTabViewController *tabBarController = [[CCWTabViewController alloc] init];
    tabBarController.selectedIndex = 2;
    CCWKeyWindow.rootViewController = tabBarController;
}

- (void)CCW_NodeAlertSheetView:(CCWNodeAlertSheetView *)alertSheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWNodeInfoModel *nodeInfo = self.nodeInfoArray[indexPath.row];
    // 最新新节点
    CCWWeakSelf;
    [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
        
        // 查询节点的chainid 是否相等
        [CCWSDKRequest CCW_QueryCurrentChainID:^(id  _Nonnull responseObject) {
            if ([nodeInfo.chainId isEqualToString:responseObject]) {
                // 节点类型
                CCWNetNotesType = nodeInfo.type;
                weakSelf.netLabel.text = nodeInfo.type?CCWLocalizable(@"主网"):CCWLocalizable(@"测试网");
                // 记录已连接的数据
                CCWSETNodeInfo([nodeInfo mj_keyValues]);
                // 判断当前链是否已经有账户
                NSArray *accountArray = [CCWSDKRequest CCW_QueryAccountList];
                if (accountArray.count > 0) {
                    CocosDBAccountModel *dbAccountModel = [accountArray firstObject];
                    CCWSETAccountName(dbAccountModel.name);
                    CCWSETAccountId(dbAccountModel.ID);
                    // 发个通知
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
                    });
                }else{
                    CCWSETAccountName(nil);
                    CCWSETAccountId(nil);
                    id<CCWInitModuleProtocol> registerModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWInitModuleProtocol)];
                    CCWNavigationController *registerController = [[CCWNavigationController alloc] initWithRootViewController:[registerModule CCW_LoginRegisterWalletViewController]];
                    CCWKeyWindow.rootViewController = registerController;
                }
            }else{
                [weakSelf.view makeToast:CCWLocalizable(@"切换失败")];
                CCWNodeInfoModel *nodeInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
                // 最新新节点
                [CCWSDKRequest CCW_InitWithUrl:nodeInfo.ws Core_Asset:nodeInfo.coreAsset Faucet_url:nodeInfo.faucetUrl ChainId:nodeInfo.chainId Success:^(id  _Nonnull responseObject) {
                    // 发个通知
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
                    });
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CCWNetConnectNetworkKey" object:nil];
            });
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            
        }];
    }];
}

// 添加自定义节点
- (void)CCW_NodeAlertSheetViewAddCustomNode:(CCWNodeAlertSheetView *)alertSheetView
{
    [self.navigationController pushViewController:[[CCWAddNodeViewController alloc] init] animated:YES];
}
@end
