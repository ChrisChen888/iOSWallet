//
//  CCWWalletHeaderView.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/13.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWWalletHeaderView.h"
#import "CCWWalletNavButton.h"

@interface CCWWalletHeaderView ()

/** 账号名称 */
@property (nonatomic, strong) UILabel *accountLabel;
/** 资产标题 */
@property (nonatomic, strong) UILabel *assetsTitleLabel;
/** 资产 */
@property (nonatomic, strong) UILabel *assetsLabel;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

/***********************导航按钮********************************/
/** 导航按钮 */
@property (nonatomic, weak) UIView *navButtonView;
/** 按钮文字 */
@property (nonatomic, strong) NSArray *buttonTitleArray;
/** 按钮图片 */
@property (nonatomic, strong) NSArray *buttonTitleImageArray;
/***********************导航按钮********************************/

/** 白色标题 */
@property (nonatomic, weak) UIView *titleHeaderView;

@end

@implementation CCWWalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"homeHeaderBg"];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.accountLabel];
    
    [self addSubview:self.assetsTitleLabel];
    [self addSubview:self.assetsLabel];
    [self addSubview:self.lineView];
    [self navButtonView];
    // 2.四个按钮
    for (int i = 0; i < 4; i++) {
        [self buttonWithIndex:i];
    }

    [self titleHeaderView];
}

// 四个导航按钮点击
- (void)navButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(CCW_HomeNavbuttonClick:button:)]) {
        [self.delegate CCW_HomeNavbuttonClick:self button:button];
    }
}

// 返回按钮
- (void)buttonWithIndex:(int)index
{
    CGFloat buttonW = 60;//CCWScreenW / 4;
    CGFloat padding = 15;// 左右间距
    CGFloat magin = (CCWScreenW - 30 - buttonW * 4) / 3;
    CGFloat buttonX = padding + index * (magin + buttonW);
    CCWWalletNavButton *button = [[CCWWalletNavButton alloc] init];
    [self.navButtonView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.height.offset(103);
        make.left.offset(buttonX);
        make.width.offset(buttonW);
    }];
    [button setImage:[UIImage imageNamed:self.buttonTitleImageArray[index]] forState:UIControlStateNormal];
    [button setTitle:CCWLocalizable(self.buttonTitleArray[index]) forState:UIControlStateNormal];
    button.tag = index;
    [button addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - lazy
- (UILabel *)assetsTitleLabel
{
    if (!_assetsTitleLabel) {
        _assetsTitleLabel = [[UILabel alloc] init];
        _assetsTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",CCWLocalizable(@"总资产"),CCWCNYORUSD?@"￥":@"$"];
        _assetsTitleLabel.font = CCWFont(14);
        _assetsTitleLabel.textColor = [UIColor whiteColor];
    }
    return _assetsTitleLabel;
}

- (UILabel *)accountLabel
{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = @"account";
        _accountLabel.textAlignment = NSTextAlignmentRight;
        _accountLabel.textColor = [UIColor whiteColor];
        _accountLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSwitchAccount)];
        [_accountLabel addGestureRecognizer:recognizer];
    }
    return _accountLabel;
}

- (UILabel *)assetsLabel
{
    if (!_assetsLabel) {
        _assetsLabel = [[UILabel alloc] init];
        _assetsLabel.text = @"0.00";
        _assetsLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:38];
        _assetsLabel.textColor = [UIColor whiteColor];
    }
    return _assetsLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.alpha = 0.1;
    }
    return _lineView;
}

- (NSArray *)buttonTitleArray
{
    if (!_buttonTitleArray) {
        _buttonTitleArray = @[CCWLocalizable(@"转账"),CCWLocalizable(@"收款"),CCWLocalizable(@"资源"),CCWLocalizable(@"投票")];
    }
    return _buttonTitleArray;
}

- (NSArray *)buttonTitleImageArray
{
    if (!_buttonTitleImageArray) {
        _buttonTitleImageArray = @[@"transferOut",@"transferIn",@"source",@"vote_icon"];
    }
    return _buttonTitleImageArray;
}

// 导航条
- (UIView *)navButtonView
{
    if (!_navButtonView) {
        UIView *navButtonView = [[UIView alloc] init];
        [self addSubview:navButtonView];
        _navButtonView = navButtonView;
    }
    return _navButtonView;
}

- (UIView *)titleHeaderView
{
    if (!_titleHeaderView) {
        UIView *titleHeaderView = [[UIView alloc] init];
        titleHeaderView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CCWScreenW, 75) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, CCWScreenW, 75);
        maskLayer.path = maskPath.CGPath;
        titleHeaderView.layer.mask = maskLayer;
        [self addSubview:titleHeaderView];
        
        // 我的资产标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = CCWLocalizable(@"我的资产");
        titleLabel.textColor = [UIColor getColor:@"323232"];
        titleLabel.font = CCWMediumFont(18);
        [titleHeaderView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(25);
        }];
        _titleHeaderView = titleHeaderView;
    }
    return _titleHeaderView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.assetsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(APP_Navgationbar_Height + 14);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(APP_Navgationbar_Height/2+10);
        make.right.offset(-15);
        make.width.offset(170);
        make.height.offset(20);
    }];
    
    CCWWeakSelf;
    [self.assetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.assetsTitleLabel);
        make.top.equalTo(weakSelf.assetsTitleLabel.mas_bottom).offset(4);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(weakSelf.assetsTitleLabel);
        make.right.offset(-15);
        make.top.equalTo(weakSelf.assetsLabel.mas_bottom).offset(27);
    }];
    
    [self.navButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-75);
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
    }];
    
    [self.titleHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.left.right.equalTo(weakSelf);
        make.height.offset(75);
    }];
}


- (void)setAccount:(NSString *)account
{
    _account = account;
    self.accountLabel.text = account;
}

// 设置资产
- (void)setAssetsNum:(NSNumber *)assetsNum
{
    _assetsNum = assetsNum;
    id cocosprice = [CCWSaveTool objectForKey:CCWCurrencyCocosPrice];
    
    NSString *totalPrice = [CCWDecimalTool CCW_multiplyTotalAssetsWithMultiplier:[NSString stringWithFormat:@"%@",cocosprice] faciend:[NSString stringWithFormat:@"%@",assetsNum]].stringValue;
    
    self.assetsLabel.text = [CCWDecimalTool CCW_convertRateWithPrice:totalPrice scale:6];
    
    self.assetsTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",CCWLocalizable(@"总资产"),CCWCNYORUSD?@"￥":@"$"];
}

- (void)clickToSwitchAccount
{
    if ([self.delegate respondsToSelector:@selector(CCW_HomeClickToswitchAccount:)]) {
        [self.delegate CCW_HomeClickToswitchAccount:self];
    }
}

@end
