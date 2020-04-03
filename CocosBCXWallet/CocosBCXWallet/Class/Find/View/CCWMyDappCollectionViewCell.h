//
//  CCWMyDappCollectionViewCell.h
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/19.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWDappModel.h"

@class CCWMyDappCollectionViewCell;

@protocol CCWDappCellDelegate <NSObject>

- (void)dappCollectionViewCellLongPressToEdit:(CCWMyDappCollectionViewCell *)dappCell;
- (void)dappCollectionViewCell:(CCWMyDappCollectionViewCell *)dappCell editToDelete:(UIButton *)editButton;

@end

@interface CCWMyDappCollectionViewCell : UICollectionViewCell
// 设置模型，和编辑状态
- (void)dappModel:(CCWDappModel *)dappModel withDelete:(BOOL)edit;

/** 代理 */
@property (nonatomic, weak) id<CCWDappCellDelegate> delegate;

@end
