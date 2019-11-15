//
//  CCWSwitchAccountView.m
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
#import "CCWSwitchAccountView.h"
#import "CCWSwitchAccountCell.h"

@interface CCWSwitchAccountView ()<UITableViewDelegate,UITableViewDataSource>
// 背后控件
@property (nonatomic, strong) UIView *containerView; // Container within the dialog (place your ui elements here)
// 关闭按钮
@property(nonatomic,strong)UIButton *closeBtn;
// 关闭按钮
@property(nonatomic,strong)UIButton *addCountBtn;
// 标题
@property(nonatomic,strong)UIImageView *coinImageView;
// 标题
@property(nonatomic,strong)UILabel *titleLabel;
// 列表
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CCWSwitchAccountView

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CCWScreenW, 275) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _containerView.layer.mask = maskLayer;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)coinImageView
{
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@"cocosIcon"];
        _coinImageView.layer.masksToBounds = YES;
        _coinImageView.layer.cornerRadius = 18;
        _coinImageView.size = CGSizeMake(36, 36);
    }
    return _coinImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor getColor:@"4f5051"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.text = [NSString stringWithFormat:@"COCOS%@",CCWLocalizable(CCWCoinTypeString)];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)addCountBtn
{
    if (!_addCountBtn) {
        _addCountBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addCountBtn setImage:[UIImage imageNamed:@"addAccount"] forState:UIControlStateNormal];
        [_addCountBtn addTarget:self action:@selector(CCW_AddAccountClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCountBtn sizeToFit];
    }
    return _addCountBtn;
}
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeBtn setImage:[UIImage imageNamed:@"closeSwitch"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(CCW_Close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        // 内容
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

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

    self.closeBtn.y = 0;
    self.closeBtn.width = CCWScreenW - 30;
    self.closeBtn.centerX = self.centerX;
    self.closeBtn.height = 42;
    [self.containerView addSubview:self.closeBtn];
    
    self.coinImageView.x = 15;
    self.coinImageView.y = 42;
    [self.containerView addSubview:self.coinImageView];
    
    self.titleLabel.x = CGRectGetMaxX(self.coinImageView.frame) + 6;
    self.titleLabel.centerY = self.coinImageView.centerY;
    [self.containerView addSubview:self.titleLabel];

    self.addCountBtn.centerY = self.titleLabel.centerY;
    self.addCountBtn.x = CCWScreenW - 40;
    [self.containerView addSubview:self.addCountBtn];
    
    CGFloat headerMaxY = CGRectGetMaxY(self.coinImageView.frame) + 10;
    CGFloat containerViewHeight = headerMaxY + 170;
    self.containerView.frame = CGRectMake(0, CCWScreenH - containerViewHeight - (iPhoneXBottomNotSafeHeight), CCWScreenW, containerViewHeight);
    self.tableView.frame = CGRectMake(0, headerMaxY, CCWScreenW, 170);
    [self.containerView addSubview:self.tableView];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        [self CCW_Close];
        return nil;
    }
    return hitView;
}


/** 显示 */
- (void)CCW_Show
{
    CGFloat headerMaxY = CGRectGetMaxY(self.coinImageView.frame);
    CGFloat tableViewH = ((self.dataSource.count)>2?2:self.dataSource.count) * 90 - 10;
    CGFloat containerViewHeight = headerMaxY + tableViewH;
    self.containerView.frame = CGRectMake(0, CCWScreenH - containerViewHeight - (iPhoneXBottomNotSafeHeight), CCWScreenW, containerViewHeight);
    self.tableView.frame = CGRectMake(0, headerMaxY, CCWScreenW, tableViewH);

    _containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
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

- (void)CCW_Close
{
    CCWWeakSelf;
    self.show = NO;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
        weakSelf.containerView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        weakSelf.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWSwitchAccountCell *cell = [CCWSwitchAccountCell cellWithTableView:tableView WithIdentifier:@"switchAccountCell"];
    cell.dbAccountModel = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(CCW_SwitchAccountView:didSelectDBAccountModel:)]) {
        [self.delegate CCW_SwitchAccountView:self didSelectDBAccountModel:self.dataSource[indexPath.row]];
    }
    [self.tableView reloadData];
    [self CCW_Close];
}

- (void)CCW_AddAccountClick
{
    [self CCW_Close];
    if ([self.delegate respondsToSelector:@selector(CCW_SwitchViewAddAccountClick:)]) {
        [self.delegate CCW_SwitchViewAddAccountClick:self];
    }
}
@end
