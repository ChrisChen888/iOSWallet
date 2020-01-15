//
//  CCWPwdAlertView.h
//  CCWPwdAlertViewDemo
//

#import <UIKit/UIKit.h>

@interface CCWPwdAlertView : UIView
/**
 初始化
 @param cancel 取消回调
 @param confirm 确认回调
 */
+ (instancetype)passwordAlertWithCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd, BOOL isIgnoreConfirm))confirm;

/**
 初始化，没有记住密码的密码框
 @param cancel 取消回调
 @param confirm 确认回调
 */
+ (instancetype)passwordAlertNoRememberWithCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd))confirm;

// Show the alert view in current window
- (void)show;

// Hide the alert view
- (void)hide;

@end
