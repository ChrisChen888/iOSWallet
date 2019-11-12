//
//  CCWMenuTextField.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/11/12.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWMenuTextField.h"

@implementation CCWMenuTextField

// 语言适配
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.placeholder = CCWLocalizable(self.placeholder);
}
@end
