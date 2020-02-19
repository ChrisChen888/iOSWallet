//
//  CCWFindViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/1/29.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWFindViewController.h"
#import "CCWFindTableViewCell.h"
#import "CCWFindFirstTableViewCell.h"
#import "CCWFindModel.h"
#import "CCWDappViewController.h"
#import "CCWSearchDAppViewController.h"
#import "CCWNavigationController.h"

@interface CCWFindViewController ()<UITableViewDataSource,UITableViewDelegate,CCWFindFirstTableViewCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, strong) NSMutableArray *banerSource;//轮播数据源
@property (nonatomic, strong) NSMutableArray *navArraySource;//四个按钮数据源

@end

@implementation CCWFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CCWLocalizable(@"发现");
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Find_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchDApp)];
    
    // tablew
    [self CCW_SetupTableView];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCWWeakSelf;
    [CCWSDKRequest CCW_QueryFindDappListSuccess:^(id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        weakSelf.banerSource = [CCWDappModel mj_objectArrayWithKeyValuesArray:dic[@"banner"]];
        weakSelf.navArraySource = [CCWDappModel mj_objectArrayWithKeyValuesArray:dic[@"nav"]];
        weakSelf.dataSource = [CCWFindModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
        [weakSelf.tableView reloadData];
    } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
        [weakSelf.view makeToast:CCWLocalizable(@"网络繁忙，请检查您的网络连接")];
    }];
}

- (void)CCW_SetupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.height -= APP_Navgationbar_Height + APP_Tabbar_Height;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.delegate = self;
    tableView.dataSource = self;
    // 设置轮播
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

// 搜索
- (void)searchDApp
{
    CCWSearchDAppViewController *search = [[CCWSearchDAppViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        CCWFindModel *findModel = self.dataSource[section-1];
        return findModel.data.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        CCWFindTableViewCell *cell = [CCWFindTableViewCell cellWithTableView:tableView WithIdentifier:@"FindCellIdentifier"];
        CCWFindModel *findModel = self.dataSource[indexPath.section-1];
        cell.dappModel = findModel.data[indexPath.row];;
        return cell;
    }else{
        CCWFindFirstTableViewCell *cell = [CCWFindFirstTableViewCell cellWithTableView:tableView WithIdentifier:@"FindCellFirstIdentifier"];
        cell.delegate = self;
        [cell setFirstCellWithCarouselImageArray:self.banerSource dappModelArray:self.navArraySource];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        CCWFindModel *findModel = self.dataSource[indexPath.section-1];
        CCWDappModel *dappModel = findModel.data[indexPath.row];
        
        // 获取是否同意过
        BOOL isjumpVC = [CCWSaveTool boolForKey:dappModel.linkUrl];
        if (isjumpVC) {
            [self CCW_PushDappViewControllerWithDapp:dappModel];
        }else{
            CCWWeakSelf
            CCWVCShowAlertCancelWithMsgHandler(CCWLocalizable(@"注意"), CCWLocalizable(@"您正在跳转至第三方dapp，确认即同意第三方dapp的用户协议与隐私政策，由其直接并单独向您承担责任"), ^(UIAlertAction * _Nonnull action) {
                [weakSelf CCW_PushDappViewControllerWithDapp:dappModel];
                [CCWSaveTool setBool:YES forKey:dappModel.linkUrl];
            });
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 94;
    } else {
        return FindSuspenHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor getColor:@"333333"];
        titleLabel.font = CCWMediumFont(22);//CCWMediumFontOfSizeForDevices(18,22,23,22);
        if (iPhone5) {
            titleLabel.font = CCWMediumFont(20);
        }
        CCWFindModel *findModel = self.dataSource[section-1];
        titleLabel.text = CCWLocalizable(findModel.header);
        [titleLabel sizeToFit];
        if (iPhone5) {
            titleLabel.y = 46 - titleLabel.height - 2;
        }else{
            titleLabel.y = 50 - titleLabel.height - 2;
        }
        titleLabel.x = 18;
        [headerView addSubview:titleLabel];
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        CGFloat heightForH = 50;
        return heightForH;
    }else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - CCWFindFirstTableViewCellDelegate
// 点击轮播图
- (void)CCW_FindFirstCellClickCarouselViewWithTableViewCell:(CCWFindFirstTableViewCell *)tableViewCell butclickImageAtIndex:(NSInteger)index
{
    CCWDappModel *dappModel = self.banerSource[index];
    [self CCW_PushDappViewControllerWithDapp:dappModel];
}
// 点击按钮
- (void)CCW_FindFirstCellClickNavButtonWithTableViewCell:(CCWFindFirstTableViewCell *)tableViewCell button:(UIButton *)button
{
    if (button.tag == 103) {
        [self.view makeToast:CCWLocalizable(@"敬请期待")];
        return;
    }
    CCWDappModel *dappModel = self.navArraySource[button.tag - 100];
    [self CCW_PushDappViewControllerWithDapp:dappModel];
}

- (void)CCW_PushDappViewControllerWithDapp:(CCWDappModel *)dappModel
{
    CCWDappViewController *dappVC = [[CCWDappViewController alloc] initWithTitle:CCWLocalizable(dappModel.title) loadDappURLString:dappModel.linkUrl dappDec:CCWLocalizable(dappModel.dec) dappIcon:dappModel.imageUrl];
    [self.navigationController pushViewController:dappVC animated:YES];
}
@end
