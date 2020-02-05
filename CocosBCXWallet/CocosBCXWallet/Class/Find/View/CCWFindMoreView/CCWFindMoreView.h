//
//  CCWFindMoreView.h
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2020/2/5.
//  Copyright © 2020 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CCWFindMoreView;
@protocol CCWFindMoreViewDelegate <NSObject>

- (void)CCW_FindMoreViewView:(CCWFindMoreView *)alertMoreView didSelectRow:(NSInteger)index;

@end

@interface CCWFindMoreView : UIView

- (void)CCW_Show;

@property (nonatomic ,weak) id<CCWFindMoreViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
