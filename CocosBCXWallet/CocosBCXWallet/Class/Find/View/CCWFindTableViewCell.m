//
//  CCWFindTableViewCell.m
//  CocosWallet
//
//  Created by SYL on 2018/11/8.
//  Copyright © 2018 CCW. All rights reserved.
//

// Dapp 图标
// Dapp 图标
#define kCCWDappPicURL @"http://api-dev.cjfan.net/wallet/static/images/dapp/"
#define CCWDappIconStrFormat(str)    [NSString stringWithFormat:@"%@%@",kCCWDappPicURL,str]

#import "CCWFindTableViewCell.h"

@interface CCWFindTableViewCell()
/** 图标 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 标题 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 注释 */
@property (nonatomic, weak) UILabel *detaiDeslLabel;
/** 底部下划线 */
@property (nonatomic, weak) UIView *lineView;
/** 右边指示 */
@property (nonatomic, weak) UIImageView *rightImageView;
@end

@implementation CCWFindTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView WithIdentifier:(NSString *)identifier
{
    CCWFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CCWFindTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

- (void)setDappModel:(CCWDappModel *)dappModel
{
    _dappModel = dappModel;
    [self.iconImageView CCW_SetImageWithURL:dappModel.imageUrl];
    BOOL isChinese = [[CCWLocalizableTool userLanguageString] isEqualToString:@"中文"];
    NSString *name = isChinese?dappModel.title:dappModel.enTitle;
    NSString *detailDes = isChinese?dappModel.dec:dappModel.enDec;
    self.nameLabel.text = name;
    self.detaiDeslLabel.text = detailDes;
}

- (void)setupSubView
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 10;
    iconImageView.clipsToBounds = YES;
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor getColor:@"262A33"];
    nameLabel.font = CCWFont(18);
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *detaiDeslLabel = [[UILabel alloc] init];
    detaiDeslLabel.textColor = [UIColor getColor:@"626670"];
    detaiDeslLabel.font = CCWFont(13);
    detaiDeslLabel.numberOfLines = 2;
    [self addSubview:detaiDeslLabel];
    self.detaiDeslLabel = detaiDeslLabel;
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.image = [UIImage imageNamed:@"rightItem"];
    [self addSubview:rightImageView];
    self.rightImageView = rightImageView;

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor getColor:@"E0E0E0"];
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconWH = 94 - 32;
    CGFloat maginCenter = 3;
    CCWWeakSelf;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(16);
        make.size.mas_equalTo(CGSizeMake(iconWH, iconWH));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-16);
        make.centerY.equalTo(weakSelf.iconImageView);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(16);
        make.right.equalTo(weakSelf).offset(-50);
//        make.bottom.equalTo(weakSelf.iconImageView.mas_centerY).offset(-maginCenter);
        make.top.equalTo(weakSelf.iconImageView);
    }];
    
    [self.detaiDeslLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.nameLabel);
        make.left.right.equalTo(weakSelf.nameLabel);
//        make.top.equalTo(weakSelf.iconImageView.mas_centerY).offset(maginCenter);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(maginCenter);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.rightImageView);
        make.height.offset(0.5);
        make.bottom.equalTo(weakSelf);
    }];
}

@end
