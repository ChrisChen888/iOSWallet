//
//  CCWNORememberContent.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/1/15.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import "CCWNORememberContent.h"
#import "CCWPwdAlertView.h"

@interface CCWNORememberContent ()

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/** 取消 */
@property (nonatomic, copy) void(^cancel)(void);

/** 确认 */
@property (nonatomic, copy) void(^confirm)(NSString *pwd);

@end

@implementation CCWNORememberContent

+ (instancetype)contentViewCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd))confirm
{
    CCWNORememberContent *contentView = [[NSBundle mainBundle] loadNibNamed:@"CCWNORememberContent" owner:nil options:nil].lastObject;
    contentView.frame = CGRectMake(0, 0, 270, 140);
    contentView.layer.cornerRadius = 4;
    contentView.clipsToBounds = YES;
    contentView.cancel = cancel;
    contentView.confirm = confirm;
    return contentView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cancelButton.layer.borderColor = [UIColor getColor:@"D1D1D1"].CGColor;
    self.cancelButton.layer.borderWidth = 0.5;
    self.confirmButton.layer.borderColor = [UIColor getColor:@"D1D1D1"].CGColor;
    self.confirmButton.layer.borderWidth = 0.5;
}

- (IBAction)cancelClick:(id)sender {
    !self.cancel?:self.cancel();
    CCWPwdAlertView *alert = (CCWPwdAlertView *)self.superview;
    [alert hide];
}

- (IBAction)confirmClick:(id)sender {
    !self.confirm?:self.confirm(self.pwdTextField.text);
    CCWPwdAlertView *alert = (CCWPwdAlertView *)self.superview;
    [alert hide];
}

- (IBAction)showOrHiddenClick:(UIButton *)sender {
    // 切换按钮的状态
    sender.selected = !sender.selected;
    if (sender.selected) { // 按下去了就是明文
        NSString *tempPwdStr = self.pwdTextField.text;
        self.pwdTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.pwdTextField.secureTextEntry = NO;
        self.pwdTextField.text = tempPwdStr;
        
    } else { // 暗文
        NSString *tempPwdStr = self.pwdTextField.text;
        self.pwdTextField.text = @"";
        self.pwdTextField.secureTextEntry = YES;
        self.pwdTextField.text = tempPwdStr;
    }
}

@end
