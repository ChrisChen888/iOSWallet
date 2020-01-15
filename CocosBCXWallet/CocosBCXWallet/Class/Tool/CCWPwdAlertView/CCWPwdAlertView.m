//
//  CCWPwdAlertView.h
//  CCWPwdAlertViewDemo
//

#import "CCWPwdAlertView.h"
#import "CCWPwdContent.h"
#import "CCWNORememberContent.h"

@interface CCWPwdAlertView ()

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIView *contentView;

@end

@implementation CCWPwdAlertView

/**
 初始化
 @param cancel 取消回调
 @param confirm 确认回调
 */
+ (instancetype)passwordAlertWithCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd, BOOL isIgnoreConfirm))confirm
{
    CCWPwdAlertView *alertVc = [[self alloc] init];
    CCWPwdContent *contentView = [CCWPwdContent contentViewCancelClick:cancel confirmClick:confirm];
    alertVc.contentView = contentView;
    return alertVc;
}

/**
 初始化，没有记住密码的密码框
 @param cancel 取消回调
 @param confirm 确认回调
 */
+ (instancetype)passwordAlertNoRememberWithCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd))confirm
{
    CCWPwdAlertView *alertVc = [[self alloc] init];
    CCWNORememberContent *contentView = [CCWNORememberContent contentViewCancelClick:cancel confirmClick:confirm];
    alertVc.contentView = contentView;
    return alertVc;
}

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}

- (void)hide {
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_contentView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}

@end
