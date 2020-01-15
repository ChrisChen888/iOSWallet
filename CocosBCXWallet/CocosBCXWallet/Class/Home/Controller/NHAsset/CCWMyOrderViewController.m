//
//  CCWMyOrderViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/18.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWMyOrderViewController.h"
#import "CCWNHAssetOrderTableViewCell.h"
#import "CCWOrderDetailViewController.h"
#import "CCWCancelSellNHInfoView.h"
#import "CCWPwdAlertView.h"

@interface CCWMyOrderViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,CCWPropOrderCellDelegate,CCWCancelSellNHInfoViewDelegate>
{
    NSInteger page;
    NSIndexPath *indexPath_;
    CCWNHAssetOrderModel *orderModel_;
}

@property (nonatomic, strong) NSMutableArray *myPropOrderArray;

/** 转账信息 */
@property (nonatomic, strong) CCWCancelSellNHInfoView *transferInfoView;

@end

@implementation CCWMyOrderViewController

- (CCWCancelSellNHInfoView *)transferInfoView
{
    if (!_transferInfoView) {
        _transferInfoView = [CCWCancelSellNHInfoView new];
        _transferInfoView.delegate = self;
    }
    return _transferInfoView;
}

- (NSMutableArray *)myPropOrderArray
{
    if (!_myPropOrderArray) {
        _myPropOrderArray = [NSMutableArray array];
    }
    return _myPropOrderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 120;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadData
{
    page = 1;
    CCWWeakSelf;
    [CCWSDKRequest CCW_ListAccountNHAssetOrder:CCWAccountId PageSize:10 Page:page Success:^(NSMutableArray *responseObject) {
        weakSelf.myPropOrderArray = responseObject;
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
    [CCWSDKRequest CCW_ListAccountNHAssetOrder:CCWAccountId PageSize:10 Page:page Success:^(NSArray *responseObject) {
        [weakSelf.myPropOrderArray addObjectsFromArray:responseObject];
        [weakSelf.tableView reloadData];
        // 结束刷新
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
    return self.myPropOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWNHAssetOrderTableViewCell *cell = [CCWNHAssetOrderTableViewCell cellWithTableView:tableView WithIdentifier:@"NHAssetOrderTableViewCell"];
    cell.nhAssetOrderModel = self.myPropOrderArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCWOrderDetailViewController *orderDetailVC = [[CCWOrderDetailViewController alloc] init];
    orderDetailVC.orderModel = self.myPropOrderArray[indexPath.row];
    orderDetailVC.orderType = CCWNHAssetOrderTypeMy;
    CCWWeakSelf;
    orderDetailVC.deleteComplete = ^(CCWNHAssetOrderType orderType) {
        if (orderType == CCWNHAssetOrderTypeMy) {
            [weakSelf.myPropOrderArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [[UIViewController topViewController].navigationController pushViewController:orderDetailVC animated:YES];
}

// 点击取消
- (void)CCWPropOrderCellbuyClick:(CCWNHAssetOrderTableViewCell *)propOrderCell
{
    indexPath_ = [self.tableView indexPathForCell:propOrderCell];
    CCWNHAssetOrderModel *orderModel = self.myPropOrderArray[indexPath_.row];
    orderModel_ = orderModel;
    
    NSArray *transferINfoArray = @[@{
                                       @"title":CCWLocalizable(@"订单信息"),
                                       @"info":CCWLocalizable(@"取消订单"),
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"订单ID"),
                                       @"info":orderModel.ID,
                                       },
                                   @{
                                       @"title":CCWLocalizable(@"NH资产ID"),
                                       @"info":orderModel.nh_asset_id,
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

- (void)CCW_CancelOrderInfoViewNextButtonClick:(CCWCancelSellNHInfoView *)transferInfoView
{
    CCWWeakSelf
    [[CCWPwdAlertView passwordAlertNoRememberWithCancelClick:^{
        NSLog(@"-----取消");
    } confirmClick:^(NSString *pwd) {
        NSLog(@"-----确认%@",pwd);
        [weakSelf cancelBuyNHAssetWIthPassword:pwd];
    }] show];
}

- (void)cancelBuyNHAssetWIthPassword:(NSString *)password
{
    CCWWeakSelf
    [CCWSDKRequest CCW_CancelSellNHAssetOrderId:orderModel_.ID Password:password Success:^(id  _Nonnull responseObject) {
        [CCWKeyWindow makeToast:CCWLocalizable(@"取消成功")];
        [weakSelf.myPropOrderArray removeObjectAtIndex:self->indexPath_.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[self->indexPath_] withRowAnimation:UITableViewRowAnimationNone];
    } Error:^(NSString * _Nonnull errorAlert, NSError *error) {
        if (error.code == 107){
            [CCWKeyWindow makeToast:CCWLocalizable(@"owner key不能进行转账，请导入active key")];
        }if (error.code == 105){
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
