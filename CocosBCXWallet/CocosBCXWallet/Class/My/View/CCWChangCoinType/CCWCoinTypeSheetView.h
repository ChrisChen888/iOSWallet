//
//  CCWCoinTypeSheetView.h
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/28.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCWCoinTypeSheetView;
@protocol CCWCoinTypeSheetViewDelegate <NSObject>

- (void)CCW_CoinTypeSheetView:(CCWCoinTypeSheetView *)alertSheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CCWCoinTypeSheetView : UIView

- (void)CCW_Show;

@property (nonatomic ,weak) id<CCWCoinTypeSheetViewDelegate> delegate;
@end
