//
//  CCWCoinTypeLabel.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/11/15.
//  Copyright © 2019 邵银岭. All rights reserved.
//

#import "CCWCoinTypeLabel.h"

@implementation CCWCoinTypeLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.text = CCWLocalizable(CCWCoinTypeString);
}


@end
