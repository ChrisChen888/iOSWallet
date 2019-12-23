//
//  CCWSelectCoinViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/4/10.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSelectCoinViewController.h"
#import "CCWWalletTableViewCell.h"
#import "CCWTransferViewController.h"
#import "CCWReceiveViewController.h"

@interface CCWSelectCoinViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation CCWSelectCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.height = self.view.height - APP_Tabbar_Height;
        tableView.delegate = self;
        tableView.dataSource = self;
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
    
    if (self.selectCoinStyle == CCWSelectCoinStyleTransfer) {
        self.title = CCWLocalizable(@"选择转账币种");
    }else{
        self.title = CCWLocalizable(@"选择收款币种");
        CCWWeakSelf;
        [CCWSDKRequest CCW_QueryChainListLimit:100 Success:^(id  _Nonnull responseObject) {
            [weakSelf.assetsModelArray removeAllObjects];
            NSMutableArray *assArray = [CCWAssetsModel mj_objectArrayWithKeyValuesArray:responseObject];
            for (CCWAssetsModel *assetsModel in assArray) {
                if (![assetsModel.symbol isEqualToString:@"GAS"]) {
                    [weakSelf.assetsModelArray addObject:assetsModel];
                }
            }
            
            weakSelf.assetsModelArray = [weakSelf.assetsModelArray sortedArrayUsingComparator:^NSComparisonResult(CCWAssetsModel *p1, CCWAssetsModel *p2){
                //对数组进行排序（升序）
                return [p1.ID compare:p2.ID];
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
            }].mutableCopy;

            [weakSelf.tableView reloadData];
        } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
            [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
        }];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWWalletTableViewCell *cell = [CCWWalletTableViewCell cellWithTableView:tableView WithIdentifier:@"WalletTableViewCell"];
    if (self.selectCoinStyle == CCWSelectCoinStyleTransfer) {
        cell.assetsModel = self.assetsModelArray[indexPath.row];
    }else{
        cell.receiveAssetsModel = self.assetsModelArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectCoinStyle == CCWSelectCoinStyleTransfer) {
        CCWTransferViewController *transferViewController = [[CCWTransferViewController alloc] init];
        transferViewController.assetsModel = self.assetsModelArray[indexPath.row];;
        [self.navigationController pushViewController:transferViewController animated:YES];
    }else{
        CCWReceiveViewController *receiveViewController = [[CCWReceiveViewController alloc] init];
        receiveViewController.assetsModel = self.assetsModelArray[indexPath.row];;
        [self.navigationController pushViewController:receiveViewController animated:YES];
    }
}

@end
