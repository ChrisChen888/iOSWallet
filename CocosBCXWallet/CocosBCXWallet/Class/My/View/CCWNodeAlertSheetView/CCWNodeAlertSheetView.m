//
//  CCWNodeAlertSheetView.m
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/28.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import "CCWNodeAlertSheetView.h"
#import "CCWNodeAlertTableViewCell.h"

@interface CCWNodeAlertSheetView()<UITableViewDelegate,UITableViewDataSource,CCWNodeAlertTableViewCellDelegate>
// 背后控件
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic ,weak) UITableView *tableView;

/** 数据源 */
@property (nonatomic ,strong) NSMutableArray *dataSource;
@end

@implementation CCWNodeAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, CCWScreenW, CCWScreenH)];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor grayColor];

        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        // 内容
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 58;
        [_containerView addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}

/** 显示 */
- (void)CCW_ShowWithDataArray:(NSMutableArray *)dataArray
{
    self.dataSource = dataArray;
    CGFloat cellH = 58;
    CGFloat cellNum = self.dataSource.count+1;
    if (self.dataSource.count > 5) {
        cellNum = 5;
    }
    CGFloat containerH = cellH * cellNum;
    self.containerView.frame = CGRectMake(0, CCWScreenH - containerH - iPhoneXBottomNotSafeHeight, CCWScreenW, containerH);
    self.tableView.frame = CGRectMake(0, 0, CCWScreenW, containerH);
    
    _containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    _containerView.alpha = 0;
    CCWWeakSelf
    [UIView animateWithDuration:0.23 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
                         weakSelf.containerView.alpha = 1;
                         weakSelf.containerView.layer.opacity = 1.0f;
                         weakSelf.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self CCW_CloseCompletion:nil];
}

- (void)CCW_CloseCompletion:(void (^)(BOOL finished))completion
{
    CCWWeakSelf;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
        weakSelf.containerView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
        !completion?:completion(finished);
    }];
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        [self removeGestureRecognizer:g];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWNodeAlertTableViewCell *cell = [CCWNodeAlertTableViewCell cellWithTableView:tableView WithIdentifier:@"myNodeAlertSheetCell"];
    if (indexPath.row == self.dataSource.count) {
        cell.coinTypeImageView.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nodeLabel.hidden = YES;
        cell.deleteButton.hidden = YES;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = CCWLocalizable(@"+ 自定义");
    }else{
        CCWNodeInfoModel *nodeInfo = self.dataSource[indexPath.row];
        cell.nodeInfoModel = nodeInfo;
        cell.delegate = self;
    }
    return cell;
}

// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count) {
        if ([self.delegate respondsToSelector:@selector(CCW_NodeAlertSheetViewAddCustomNode:)]) {
            [self.delegate CCW_NodeAlertSheetViewAddCustomNode:self];
        }
        [self CCW_CloseCompletion:nil];
        return;
    }
    BOOL canSelect = YES;
    CCWNodeInfoModel *nodeInfo = self.dataSource[indexPath.row];
    CCWNodeInfoModel *saveNodelInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
//    if ([saveNodelInfo.ws isEqualToString:nodeInfo.ws] && [saveNodelInfo.chainId isEqualToString:nodeInfo.chainId] && [saveNodelInfo.faucetUrl isEqualToString:nodeInfo.faucetUrl] && [saveNodelInfo.coreAsset isEqualToString:nodeInfo.coreAsset]) {
//        canSelect = NO;
//    }
    if (canSelect) {
        if ([self.delegate respondsToSelector:@selector(CCW_NodeAlertSheetView:didSelectRowAtIndexPath:)]) {
            [self.delegate CCW_NodeAlertSheetView:self didSelectRowAtIndexPath:indexPath];
        }
        [tableView reloadData];
    }
    [self CCW_CloseCompletion:nil];
}

- (void)CCW_NodeAlertCell:(CCWNodeAlertTableViewCell *)alertCell nodeInfo:(CCWNodeInfoModel *)nodeInfoModel
{
    
    self.dataSource = [[CCWDataBase CCW_shareDatabase] CCW_DeleteNodeInfo:nodeInfoModel];
    
    if ([self.delegate respondsToSelector:@selector(CCW_NodeAlertCellDeleteNodel:nodeArray:)]) {
        [self.delegate CCW_NodeAlertCellDeleteNodel:self nodeArray:self.dataSource];
    }
    [self.tableView reloadData];
}

@end
