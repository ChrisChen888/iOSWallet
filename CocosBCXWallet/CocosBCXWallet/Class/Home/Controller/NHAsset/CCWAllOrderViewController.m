//
//  CCWAllOrderViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/18.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWAllOrderViewController.h"
#import "CCWNHAssetOrderTableViewCell.h"
#import "CCWOrderDetailViewController.h"
#import "CCWBuyNHInfoView.h"
#import "CCWPwdAlertView.h"

@interface CCWAllOrderViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,CCWPropOrderCellDelegate,CCWBuyNHInfoViewDelegate>
{
    NSInteger page;
    NSIndexPath *indexPath_;
    CCWNHAssetOrderModel *orderModel_;
}

@property (nonatomic, strong) NSMutableArray *allPropOrderArray;
/** 转账信息 */
@property (nonatomic, strong) CCWBuyNHInfoView *transferInfoView;

@end

@implementation CCWAllOrderViewController

- (CCWBuyNHInfoView *)transferInfoView
{
    if (!_transferInfoView) {
        _transferInfoView = [CCWBuyNHInfoView new];
        _transferInfoView.delegate = self;
    }
    return _transferInfoView;
}

- (NSMutableArray *)allPropOrderArray
{
    if (!_allPropOrderArray) {
        _allPropOrderArray = [NSMutableArray array];
    }
    return _allPropOrderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadData
{
    page = 1;
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryAllNHAssetOrder:@"" WorldView:@"" BaseDescribe:@"" PageSize:10 Page:page Success:^(NSArray *responseObject) {
        weakSelf.allPropOrderArray = responseObject.mutableCopy;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (responseObject.count < 1) {
            weakSelf.tableView.mj_footer = nil;
        }else if (responseObject.count < 10){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [CCWKeyWindow makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData
{
    page += 1;
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryAllNHAssetOrder:@"" WorldView:@"" BaseDescribe:@"" PageSize:10 Page:page Success:^(NSArray *responseObject) {
        [weakSelf.allPropOrderArray addObjectsFromArray:responseObject];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (responseObject.count < 10) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [CCWKeyWindow makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allPropOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWNHAssetOrderTableViewCell *cell = [CCWNHAssetOrderTableViewCell cellWithTableView:tableView WithIdentifier:@"CCWallOrderTableViewCell"];
    cell.allOrderModel = self.allPropOrderArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCWOrderDetailViewController *orderDetailVC = [[CCWOrderDetailViewController alloc] init];
    orderDetailVC.orderModel = self.allPropOrderArray[indexPath.row];
    orderDetailVC.orderType = CCWNHAssetOrderTypeAllNet;
    CCWWeakSelf;
    orderDetailVC.deleteComplete = ^(CCWNHAssetOrderType orderType) {
        if (orderType == CCWNHAssetOrderTypeAllNet) {
            [weakSelf.allPropOrderArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [[UIViewController topViewController].navigationController pushViewController:orderDetailVC animated:YES];
}

// 购买
- (void)CCWPropOrderCellbuyClick:(CCWNHAssetOrderTableViewCell *)propOrderCell
{
    
    indexPath_ = [self.tableView indexPathForCell:propOrderCell];
    orderModel_ = self.allPropOrderArray[indexPath_.row];
    if ([orderModel_.seller isEqualToString:CCWAccountId]) {
        [CCWKeyWindow makeToast:CCWLocalizable(@"不能购买自己创建的订单")];
        return;
    }
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"购买资产"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单ID"),
                                       @"info":orderModel_.ID,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":orderModel_.nh_asset_id,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单价格"),
                                       @"info":[NSString stringWithFormat:@"%@ %@",orderModel_.priceModel.amount,orderModel_.priceModel.symbol],
                                       }];
    [self CCW_TransferInfoViewShowWithArray:transferINfoArray];
 
}

- (void)CCW_TransferInfoViewShowWithArray:(NSArray *)array
{
    self.transferInfoView.dataSource = array;
    if (self.transferInfoView.isShow) {
        [self.transferInfoView CCW_CloseCompletion:nil];
    }else{
        [self.transferInfoView CCW_Show];
    }
}
- (void)CCW_BuyInfoViewNextButtonClick:(CCWBuyNHInfoView *)transferInfoView
{
    // 输入密码
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
    } confirmClick:^(NSString *pwd) {
        [weakSelf buyNHAssetWithPassword:pwd];
    }] show];
}

- (void)buyNHAssetWithPassword:(NSString *)password{
    
    CCWWeakSelf
    [CCWSDKRequest CCW_BugNHAssetOrderId:orderModel_.ID Password:password Success:^(id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"购买成功")];
        [weakSelf.allPropOrderArray removeObjectAtIndex:self->indexPath_.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[self->indexPath_] withRowAnimation:UITableViewRowAnimationNone];
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if ([error.userInfo[@"message"] containsString:@"insufficient_balance"]){
            [CCWKeyWindow makeToast:CCWLocalizable(@"余额不足")];
        }else if (error.code == 107){
            [CCWKeyWindow makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
        }else if (error.code == 105){
            [CCWKeyWindow makeToast:CCWLocalizable(@"密码错误，请重新输入")];
        }else{
            [CCWKeyWindow makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }
    }];
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
    return  -90;
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}
@end
