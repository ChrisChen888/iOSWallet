//
//  CCWMyDappCollectionViewCell.m
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/19.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import "CCWMyDappCollectionViewCell.h"

@interface CCWMyDappCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

/** 模型 */
@property (nonatomic, strong) CCWDappModel *dappModel;
@end

@implementation CCWMyDappCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEditAction:)];
    [self.imageView addGestureRecognizer:longPressGR];
}

// 设置模型，和编辑状态
- (void)dappModel:(CCWDappModel *)dappModel withDelete:(BOOL)edit
{
    _dappModel = dappModel;
    self.labelTitle.text = dappModel.title;
    [self.imageView CCW_SetImageWithURL:dappModel.logo];
    self.editButton.hidden = !edit;
}

- (IBAction)deleteCellModel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dappCollectionViewCell:editToDelete:)]) {
        [self.delegate dappCollectionViewCell:self editToDelete:sender];
    }
}

// 长按编辑
- (void)longPressEditAction:(UILongPressGestureRecognizer* )gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(dappCollectionViewCellLongPressToEdit:)]) {
            [self.delegate dappCollectionViewCellLongPressToEdit:self];
        }
    }
    
}
@end
