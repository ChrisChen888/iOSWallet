//
//  CCWLogOutAlert.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/5/24.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWLogOutAlert.h"

@implementation CCWLogOutAlert

// 标题
- (NSString *)showWithTitle {
    
    return CCWLocalizable(@"提示");
}

// 展示内容
- (NSString *)showWithMessage {
    
    return CCWLocalizable(@"退出账号前，请确保您已保存私钥");
}

// 自定义消息栏
- (UIView *)messageView:(UILabel *)oringeMessage {
    
    oringeMessage.textAlignment = NSTextAlignmentLeft;
    if (iPhone5 || iPhone4S) {
        oringeMessage.font = [UIFont systemFontOfSize:12];
        CGFloat height = [oringeMessage.text heightWithFont:oringeMessage.font MaxWidth:oringeMessage.width];
        oringeMessage.height = height;
    }
    return oringeMessage;
}

@end
