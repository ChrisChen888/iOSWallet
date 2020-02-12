//
//  CCWCancelSellNHInfoView.m
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
#import "CCWCancelSellNHInfoView.h"
#import "CCWTransferInfoTableViewCell.h"

#define containerViewH 297

@interface CCWCancelSellNHInfoView ()<UITableViewDelegate,UITableViewDataSource>
// 背后控件
@property (nonatomic, strong) UIView *containerView; // Container within the dialog (place your ui elements here)

// 关闭按钮
@property(nonatomic,strong)UIButton *closeBtn;
/** 下一步按钮 */
@property (nonatomic, strong) UIButton *nextBtn;
// 标题
@property(nonatomic,strong)UILabel *titleLabel;
// 列表
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CCWCancelSellNHInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self setFrame:CGRectMake(0, 0, CCWScreenW, CCWScreenH)];
    self.backgroundColor = [UIColor grayColor];
    
    // 标题
    [self titleLabel];
    [self nextBtn];
    CGFloat containerViewHeight = containerViewH;
    self.containerView.frame = CGRectMake(0, CCWScreenH - containerViewHeight - (iPhoneXBottomNotSafeHeight), CCWScreenW, containerViewHeight);
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CCWScreenW, containerViewH) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _containerView.layer.mask = maskLayer;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 15, 30, 30)];
        [_closeBtn setImage:[UIImage imageNamed:@"closeInfoButton"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(CCW_CloseView) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame) + 24, CCWScreenW - 30, 50)];
        _nextBtn.backgroundColor = CCWButtonBgColor;
        _nextBtn.layer.cornerRadius = 6;
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:CCWFont(16)];
        [_nextBtn setTitle:CCWLocalizable(@"下一步") forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(CCW_nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:_nextBtn];
    }
    return _nextBtn;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor getColor:@"262A33"];
        _titleLabel.font = CCWFont(18);
        _titleLabel.text = CCWLocalizable(@"交易详情");
        [_titleLabel sizeToFit];
        _titleLabel.centerY = self.closeBtn.centerY;
        _titleLabel.centerX = self.centerX;
        [self.containerView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        // 内容
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, CCWScreenW, iPhone5?132:150)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = iPhone5?44:50;
        _tableView.scrollEnabled = NO;
        [self.containerView addSubview:_tableView];
    }
    return _tableView;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)CCW_CloseView {
    [self CCW_CloseCompletion:nil];
}

/** 显示 */
- (void)CCW_Show
{
    _containerView.layer.transform = CATransform3DMakeTranslation(0, containerViewH ,0);
    [self addSubview:_containerView];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    _containerView.alpha = 0;
    self.show = YES;
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
//    [self CCW_Close];
}

- (void)CCW_CloseCompletion:(void (^)(BOOL finished))completion
{
    CCWWeakSelf;
    self.show = NO;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0,containerViewH ,0);
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

- (void)CCW_nextBtnClick
{
    CCWWeakSelf
    [self CCW_CloseCompletion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(CCW_CancelOrderInfoViewNextButtonClick:)]) {
            [weakSelf.delegate CCW_CancelOrderInfoViewNextButtonClick:self];
        }
    }];
}
#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWTransferInfoTableViewCell *cell = [CCWTransferInfoTableViewCell cellWithTableView:tableView WithIdentifier:@"transferInfoTableViewCell"];
    cell.dataDic = self.dataSource[indexPath.row];
    return cell;
}

@end
