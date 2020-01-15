//
//  CCWNORememberContent.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/1/15.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCWNORememberContent : UIView

+ (instancetype)contentViewCancelClick:(void (^)(void))cancel confirmClick:(void (^)(NSString *pwd))confirm;

@end

NS_ASSUME_NONNULL_END
