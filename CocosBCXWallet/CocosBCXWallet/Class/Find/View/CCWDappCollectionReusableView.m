//
//  CCWDappCollectionReusableView.m
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/19.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import "CCWDappCollectionReusableView.h"

@implementation CCWDappCollectionReusableView

/* 获取顶部视图对象 */
+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView identifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    //从缓存池中寻找顶部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的顶部视图返回
    CCWDappCollectionReusableView *headerView =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    return headerView;
}
/* 注册了顶部视图后，当缓存池中没有顶部视图的对象时候，自动调用alloc/initWithFrame创建 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建label
        UILabel *textLabel = [[UILabel alloc] init];
        //设置label尺寸
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        textLabel.frame = CGRectMake(16, 0, width, height);
        //设置label属性
        textLabel.font = CCWMediumFont(16);
        if (iPhone6SP) {
            textLabel.font = CCWMediumFont(18);
        }
        textLabel.textColor = [UIColor getColor:@"333333"];
        textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel = textLabel;
        //添加到父控件
        [self addSubview:textLabel];
    }
    return self;
}

@end
