//
//  CCWFindMoreView.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/2/5.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWFindMoreView.h"
#import "CCWFindButton.h"

@interface CCWFindMoreView ()
// 背后控件
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation CCWFindMoreView
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@{@"title":@"刷新",
                          @"image":@"findrefresh"},
                        @{@"title":@"复制URL",
                          @"image":@"findcopy"},
                        @{@"title":@"分享",
                          @"image":@"findshare"},
                        @{@"title":@"浏览器打开",
                          @"image":@"findsafari"},];
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, CCWScreenW, CCWScreenH)];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor grayColor];
        
        // 弹出框高度
        [self addSubview:self.containerView];
        
    }
    return self;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat containerH = 170;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CCWScreenH - containerH - iPhoneXBottomNotSafeHeight, CCWScreenW, containerH)];
        _containerView.backgroundColor = [UIColor getColor:@"EFF0F1"];
        // 遍历加入button
        CGFloat buttonH = 100;
        CGFloat buttonW = CCWScreenW / 4;
        for (int i = 0; i < 4; i++) {
            CCWFindButton *button = [[CCWFindButton alloc] init];
            button.tag = i+1;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            NSDictionary *data = self.dataSource[i];
            [button setTitle:CCWLocalizable(data[@"title"]) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:data[@"image"]] forState:UIControlStateNormal];
            button.frame = CGRectMake(i * buttonW, 10, buttonW, buttonH);
            [_containerView addSubview:button];
            [button setTitleColor:[UIColor getColor:@"606162"] forState:UIControlStateNormal];
        }
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.frame = CGRectMake(0, 120, CCWScreenW, 50);
        cancelButton.backgroundColor = [UIColor whiteColor];
        cancelButton.userInteractionEnabled = NO;
        [cancelButton setTitle:CCWLocalizable(@"取消") forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitleColor:[UIColor getColor:@"606162"] forState:UIControlStateNormal];
        [_containerView addSubview:cancelButton];
        
    }
    return _containerView;
}

/** 显示 */
- (void)CCW_Show
{
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

- (void)buttonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(CCW_FindMoreViewView:didSelectRow:)]) {
        [self.delegate CCW_FindMoreViewView:self didSelectRow:button.tag];
    }
    [self CCW_CloseCompletion:nil];
}
@end
