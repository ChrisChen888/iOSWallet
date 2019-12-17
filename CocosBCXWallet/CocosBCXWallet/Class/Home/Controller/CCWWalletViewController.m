//
//  CCWWalletViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/1/29.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWWalletViewController.h"
#import "CCWWalletHeaderView.h"
#import "CCWWalletTableViewCell.h"
#import "CCWTransRecordViewController.h"
#import "CCWSwitchAccountView.h"
#import "CCWTransferViewController.h"
#import "CCWWalletTableView.h"
#import "CCWSelectCoinViewController.h"
#import "CCWCheckVisionAlert.h"
#import "CCWNavigationController.h"
#import "CCWRegisterTableViewCell.h"

@interface CCWWalletViewController ()<UITableViewDelegate,UITableViewDataSource,CCWWalletHeaderDelegate,CCWSwitchAccountViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 当前登录账户名 */
@property (nonatomic, copy) NSString *accountName;
/** 资产个数 */
@property (nonatomic, strong) NSMutableArray *assetsModelArray;

/** tableView */
@property (nonatomic, weak) CCWWalletTableView *tableView;

/** <#视图#> */
@property (nonatomic, strong) CCWSwitchAccountView *switchAccountView;

/** 头部 */
@property (nonatomic, weak) CCWWalletHeaderView *headerView;
@end

@implementation CCWWalletViewController

- (NSMutableArray *)assetsModelArray
{
    if (!_assetsModelArray) {
        _assetsModelArray = [NSMutableArray array];
    }
    return _assetsModelArray;
}

- (CCWSwitchAccountView *)switchAccountView
{
    if (!_switchAccountView) {
        _switchAccountView = [CCWSwitchAccountView new];
        _switchAccountView.delegate = self;
    }
    return _switchAccountView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
    
    [self CCW_RequestAPPVersionInfo];
}

// 获取版本信息
- (void)CCW_RequestAPPVersionInfo
{
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
        NSLog(@"----errorAlert----%@",errorAlert);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self connectSuccess];
}

- (void)connectSuccess
{
    CCWWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!CCWAccountId) {
            self.headerView.account = @"";
            [weakSelf.tableView reloadData];
        }else{
            NSString *accountName = CCWAccountName;
            if (accountName.length > 13) {
                accountName = [accountName substringToIndex:13];//截取掉下标5之前的字符串
                accountName = [NSString stringWithFormat:@"%@...",accountName];
            }
            self.headerView.account = [NSString stringWithFormat:@"%@ >",accountName];
            
            // 查询资产
            [CCWSDKRequest CCW_QueryAccountAllBalances:CCWAccountId Success:^(NSMutableArray *responseObject) {
                [weakSelf.assetsModelArray removeAllObjects];
                for (CCWAssetsModel *assetsModel in responseObject) {
                    if (![assetsModel.asset_id isEqualToString:@"1.3.1"]) {
                        [weakSelf.assetsModelArray addObject:assetsModel];
                    }
                }
                [weakSelf.tableView reloadData];
            } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
                //        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
            }];
        }
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 初始化
- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = nil;
    
    // 设置导航
    [self ccw_setNavBarTintColor:[UIColor whiteColor]];
    [self ccw_setNavBarHidden:YES];
    [self ccw_setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:@"CCWNetConnectNetworkKey" object:nil];
    
    NSString *accountName = CCWAccountName;
    if (accountName.length > 13) {
        accountName = [accountName substringToIndex:13];//截取掉下标5之前的字符串
        accountName = [NSString stringWithFormat:@"%@...",accountName];
    }
    
    CCWWalletHeaderView *headerView = [[CCWWalletHeaderView alloc] init];
    headerView.width = CCWScreenW;
    headerView.height = 269 + (IPHONE_X?APP_StatusBar_Height-10:0) + 75;
    headerView.delegate = self;
    headerView.account = [NSString stringWithFormat:@"%@ >",accountName];
    self.headerView = headerView;
    CCWWalletTableView *tableView = ({
        CCWWalletTableView *tableView = [[CCWWalletTableView alloc] initWithFrame:self.view.bounds];
        tableView.height = self.view.height - APP_Tabbar_Height;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = headerView;
        tableView.rowHeight = 82;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior =
            UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tableView;
    });
    self.tableView = tableView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - tableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (!CCWAccountId) {
        return 70;
    }
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!CCWAccountId) {
        return 1;
    }
    return self.assetsModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!CCWAccountId) {
        CCWRegisterTableViewCell *cell = [CCWRegisterTableViewCell cellWithTableView:tableView WithIdentifier:@"RegisterCell"];
        return cell;
    }else{
        CCWWalletTableViewCell *cell = [CCWWalletTableViewCell cellWithTableView:tableView WithIdentifier:@"WalletTableViewCell"];
        cell.assetsModel = self.assetsModelArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!CCWAccountId) {
        id<CCWInitModuleProtocol> initModule  = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWInitModuleProtocol)];
        [self.navigationController pushViewController:[initModule CCW_LoginRegisterWalletViewController] animated:YES];
    }else{
        CCWTransRecordViewController *transRecordViewController = [[CCWTransRecordViewController alloc] init];
        transRecordViewController.assetsModel = self.assetsModelArray[indexPath.row];
        [self.navigationController pushViewController:transRecordViewController animated:YES];
    }
}

// 切换账号
- (void)CCW_HomeClickToswitchAccount:(CCWWalletHeaderView *)walletHeaderView
{
    // 获取账户列表
    self.switchAccountView.dataSource = [CCWSDKRequest CCW_QueryAccountList];
    if (self.switchAccountView.isShow) {
        [self.switchAccountView CCW_Close];
    }else{
        [self.switchAccountView CCW_Show];
    }
}

// 按钮点击
- (void)CCW_HomeNavbuttonClick:(CCWWalletHeaderView *)walletHeaderView button:(UIButton *)button
{
    
    if (!CCWAccountId) {
        [self.view makeToast:CCWLocalizable(@"请登陆/注册后再试")];
        return;
    }
    switch (button.tag) {
        case 0:
        {
            CCWSelectCoinViewController *selectVC = [[CCWSelectCoinViewController alloc] init];
            selectVC.selectCoinStyle = CCWSelectCoinStyleTransfer;
            selectVC.assetsModelArray = self.assetsModelArray;
            [self.navigationController pushViewController:selectVC animated:YES];
        }
            break;
        case 1:
        {
            CCWSelectCoinViewController *selectVC = [[CCWSelectCoinViewController alloc] init];
            selectVC.selectCoinStyle = CCWSelectCoinStyleReceive;
            selectVC.assetsModelArray = self.assetsModelArray;
            [self.navigationController pushViewController:selectVC animated:YES];
        }
            break;
        case 2:
        {
            id<CCWFindModuleProtocol> findModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWFindModuleProtocol)];
            UIViewController *viewController = [findModule CCW_FindWebViewControllerWithTitle:CCWLocalizable(@"资源") loadDappURLString:@"https://gas.cocosbcx.net/"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 3:
        {
            id<CCWFindModuleProtocol> findModule = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWFindModuleProtocol)];
            UIViewController *viewController = [findModule CCW_FindWebViewControllerWithTitle:CCWLocalizable(@"投票") loadDappURLString:@"https://vote.cocosbcx.net/"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;

        default:
            break;
    }
}

- (void)CCW_SwitchAccountView:(CCWSwitchAccountView *)switchAccountView didSelectDBAccountModel:(CocosDBAccountModel *)dbAccountModel
{
    CCWSETAccountId(dbAccountModel.ID);
    CCWSETAccountName(dbAccountModel.name);
    [self connectSuccess];
    NSString *accountName = CCWAccountName;
    if (accountName.length > 13) {
        accountName = [accountName substringToIndex:13];//截取掉13位
        accountName = [NSString stringWithFormat:@"%@...",accountName];
    }
    self.headerView.account = [NSString stringWithFormat:@"%@ >",accountName];
}

- (void)CCW_SwitchViewAddAccountClick:(CCWSwitchAccountView *)switchAccountView
{
    id<CCWInitModuleProtocol> initModule  = [[CCWMediator sharedInstance] moduleForProtocol:@protocol(CCWInitModuleProtocol)];
    [self.navigationController pushViewController:[initModule CCW_CreateWalletViewController] animated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"noData"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 70;
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

@end
