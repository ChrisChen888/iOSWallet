//
//  CocosCodeView.m
//  CocosHDWallet
//
//  Created by 邵银岭 on 2019/1/14.
//  Copyright © 2019年 邵银岭. All rights reserved.
//
#import "CocosCodeView.h"

@interface CocosCodeView ()
// 背后控件
@property (nonatomic, strong) UIView *containerView; // Container within the dialog (place your ui elements here)
// 标题
@property(nonatomic,strong)UILabel *titleLabel;
// 内容
@property(nonatomic,strong)UITextView *codeTextView;

@end

@implementation CocosCodeView

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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor getColor:@"4f5051"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = CCWLocalizable(@"合约详情");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UITextView *)codeTextView {
    if (!_codeTextView) {
        _codeTextView = [UITextView new];
        _codeTextView.textColor = [UIColor getColor:@"4f304f"];
        _codeTextView.font = [UIFont boldSystemFontOfSize:14];
        _codeTextView.editable = NO;
    }
    return _codeTextView;
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

    self.titleLabel.x =  6;
    self.titleLabel.y = 10;
    self.titleLabel.width = CCWScreenW - 12;
    [self.containerView addSubview:self.titleLabel];
    
    self.codeTextView.x = 10;
    self.codeTextView.y = CGRectGetMaxY(self.titleLabel.frame);
    self.codeTextView.width = CCWScreenW - 20;
    self.codeTextView.height = 210;
    [self.containerView addSubview:self.codeTextView];
    
    CGFloat containerViewHeight = CGRectGetMaxY(self.codeTextView.frame) + 10;
    self.containerView.frame = CGRectMake(0, CCWScreenH - containerViewHeight - (iPhoneXBottomNotSafeHeight), CCWScreenW, containerViewHeight);
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        [self Cocos_CloseCompletion:nil];
        return nil;
    }
    return hitView;
}


/** 显示 */
- (void)Cocos_Show
{
    self.codeTextView.text = self.codeString;
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

- (void)Cocos_CloseCompletion:(void (^)(BOOL finished))completion
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
        !completion?:completion(finished);
    }];
}

@end
