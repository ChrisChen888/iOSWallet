//
//  CCWSelectSellCoinViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/7/24.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWSelectSellCoinViewController.h"
#import "CCWSellCoinTypeTableViewCell.h"

@interface CCWSelectSellCoinViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

/** 币种 */
@property (nonatomic, strong) NSMutableArray *coinArray;
@end

@implementation CCWSelectSellCoinViewController

- (NSMutableArray *)coinArray
{
    if (!_coinArray) {
        _coinArray = [NSMutableArray array];
    }
    return _coinArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CCWLocalizable(@"币种选择");
    self.view.backgroundColor = [UIColor getColor:@"F6F7FB"];
    
    UITableView *tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.height = self.view.height;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 70;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView = tableView;
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryChainListLimit:100 Success:^(id  _Nonnull responseObject) {
        [weakSelf.coinArray removeAllObjects];
        NSMutableArray *assArray = [CCWAssetsModel mj_objectArrayWithKeyValuesArray:responseObject];
        for (CCWAssetsModel *assetsModel in assArray) {
            if (![assetsModel.symbol isEqualToString:@"GAS"]) {
                [weakSelf.coinArray addObject:assetsModel];
            }
        }
        [weakSelf.tableView reloadData];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coinArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWSellCoinTypeTableViewCell *cell = [CCWSellCoinTypeTableViewCell cellWithTableView:tableView WithIdentifier:@"SellCoinTypeTableViewCell"];
    CCWAssetsModel *cellModel = self.coinArray[indexPath.row];
    if ([self.selectAssetModel.ID isEqualToString:cellModel.ID]) {
        cellModel.selectAsset = YES;
    }
    cell.assetModel = cellModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.coinArray enumerateObjectsUsingBlock:^(CCWAssetsModel *rowCellModel, NSUInteger idx, BOOL * _Nonnull stop) {
        rowCellModel.selectAsset = NO;
    }];
    self.selectAssetModel = self.coinArray[indexPath.row];
    [tableView reloadData];
    !self.selectBlock?:self.selectBlock(self.selectAssetModel);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
