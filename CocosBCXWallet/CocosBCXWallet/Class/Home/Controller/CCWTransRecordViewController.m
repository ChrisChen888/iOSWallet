//
//  CCWTransRecordViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTransRecordViewController.h"
#import "CCWTransferRecordHeader.h"
#import "CCWTransRecordTableViewCell.h"
#import "CCWTransferViewController.h"
#import "CCWTransferDetailViewController.h"
#import "CCWTransferRecordTableView.h"
#import "CCWReceiveViewController.h"

@interface CCWTransRecordViewController ()<UITableViewDelegate,UITableViewDataSource,CCWTransferRecordHeaderDelegate>

@property (nonatomic, weak) CCWTransferRecordTableView *tableView;
@property (nonatomic, strong) NSMutableArray *transferArray;
@property (nonatomic, weak) CCWTransferRecordHeader *headerView;

@end

@implementation CCWTransRecordViewController

- (NSMutableArray *)transferArray
{
    if (!_transferArray) {
        _transferArray = [NSMutableArray array];
    }
    return _transferArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *accountId = CCWAccountId;
    CCWWeakSelf
    // 查询资产个数
    [CCWSDKRequest CCW_QueryAccountBalances:accountId assetId:self.assetsModel.asset_id Success:^(CCWAssetsModel *  _Nonnull responseObject) {
        weakSelf.assetsModel.amount = responseObject.amount;
        weakSelf.headerView.assetsModel = responseObject;
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
    
    // 查询交易记录
    [MBProgressHUD showLoadingMessage:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
//        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    });
    [CCWSDKRequest CCW_QueryUserOperations:accountId limit:100 Success:^(NSArray * _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.transferArray removeAllObjects];
        [responseObject enumerateObjectsUsingBlock:^(CCWTransRecordModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.oprationType == CCWOpTypeNHTransfer || obj.oprationType == CCWOpTypeTransition || obj.oprationType == CCWOpTypeCallContract) {
                [weakSelf.transferArray addObject:obj];
            }
            if (idx + 1 == responseObject.count) {
                // 刷新
                [weakSelf.tableView reloadData];
            }
        }];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUD];
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CCWLocalizable(@"交易记录");
    [self ccw_setNavBackgroundColor:[UIColor getColor:@"D2D9F3"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CCWTransferRecordHeader *headerView = [CCWTransferRecordHeader transferRecordHeader];
    headerView.width = CCWScreenW;
    headerView.delegate = self;
    self.headerView = headerView;
    
    CCWTransferRecordTableView *tableView = ({
        CCWTransferRecordTableView *tableView = [[CCWTransferRecordTableView alloc] initWithFrame:self.view.bounds];
        tableView.height -= APP_Navgationbar_Height;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = headerView;
        tableView.rowHeight = 82;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView = tableView;
    
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transferArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWTransRecordTableViewCell *cell = [CCWTransRecordTableViewCell cellWithTableView:tableView WithIdentifier:@"transRecordTableViewCell"];
    cell.transRecordModel = self.transferArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCWTransferDetailViewController *transferDetailViewController = [[CCWTransferDetailViewController alloc] init];
    transferDetailViewController.transRecordModel = self.transferArray[indexPath.row];
    [self.navigationController pushViewController:transferDetailViewController animated:YES];
}

#pragma mark - CCWTransferRecordHeaderDelegate
- (void)transferRecordHeaderCopyAddressClick:(CCWTransferRecordHeader *)headerView
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:CCWAccountName];
    [self.view makeToast:CCWLocalizable(@"复制成功")];
}

// 转账
- (void)transferRecordHeaderTransferClick:(CCWTransferRecordHeader *)headerView
{
    CCWTransferViewController *transferViewController = [[CCWTransferViewController alloc] init];
    transferViewController.assetsModel = self.assetsModel;
    [self.navigationController pushViewController:transferViewController animated:YES];
}

- (void)transferRecordHeaderReceivClick:(CCWTransferRecordHeader *)headerView
{
    CCWReceiveViewController *receiveViewController = [[CCWReceiveViewController alloc] init];
    receiveViewController.assetsModel = self.assetsModel;
    [self.navigationController pushViewController:receiveViewController animated:YES];
}

@end
