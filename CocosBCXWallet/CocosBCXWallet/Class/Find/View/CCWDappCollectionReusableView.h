//
//  CCWDappCollectionReusableView.h
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/19.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCWDappCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) UILabel *textLabel;

/* 获取顶部视图对象 */
+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end
