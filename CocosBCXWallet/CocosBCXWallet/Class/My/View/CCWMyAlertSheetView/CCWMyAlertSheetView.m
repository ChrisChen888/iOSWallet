//
//  CCWMyAlertSheetView.m
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/28.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import "CCWMyAlertSheetView.h"
#import "CCWMySheetTableViewCell.h"

@interface CCWMyAlertSheetView()<UITableViewDelegate,UITableViewDataSource>
// 背后控件
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)
/** 数据源 */
@property (nonatomic ,strong) NSMutableArray *dataSource;

@property (nonatomic ,weak) UITableView *tableView;
@end

@implementation CCWMyAlertSheetView

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"中文",@"English",CCWLocalizable(@"取消")].mutableCopy;
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, CCWScreenW, CCWScreenH)];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor grayColor];

        CGFloat cellH = 58;
        // 弹出框高度
        CGFloat containerH = cellH * self.dataSource.count;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CCWScreenH - containerH - iPhoneXBottomNotSafeHeight, CCWScreenW, containerH)];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        // 内容
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CCWScreenW, containerH)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = cellH;
        [_containerView addSubview:tableView];
        self.tableView = tableView;
    }
    return self;
}

/** 显示 */
- (void)CCW_Show
{
    _containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    _containerView.alpha = 0;
    CCWWeakSelf
    [UIView animateWithDuration:0.23 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
                         weakSelf.containerView.alpha = 1;
                         weakSelf.containerView.layer.opacity = 1.0f;
                         weakSelf.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self CCW_CloseCompletion:nil];
}

- (void)CCW_CloseCompletion:(void (^)(BOOL finished))completion
{
    CCWWeakSelf;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        weakSelf.containerView.layer.transform = CATransform3DMakeTranslation(0,200 ,0);
        weakSelf.containerView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
        !completion?:completion(finished);
    }];
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        [self removeGestureRecognizer:g];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCWMySheetTableViewCell *cell = [CCWMySheetTableViewCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle WithIdentifier:@"myAlertSheetCell"];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    BOOL isChinese = [[CCWLocalizableTool userLanguageString] isEqualToString:@"中文"];
    if (indexPath.row == 0) {
        cell.coinTypeImageView.image = [UIImage imageNamed:isChinese?@"languageSelect":@"languageNomal"];
    }else if (indexPath.row == 1){
        cell.coinTypeImageView.image = [UIImage imageNamed:isChinese?@"languageNomal":@"languageSelect"];
    }else if (indexPath.row == 2) {
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.coinTypeImageView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [CCWLocalizableTool setUserlanguage:CCWLanzh];
    }else if (indexPath.row == 1){
        [CCWLocalizableTool setUserlanguage:CCWLanEn];
    }else{
      [self CCW_CloseCompletion:nil];
    }
    if ([self.delegate respondsToSelector:@selector(CCW_MyAlertSheetView:didSelectRowAtIndexPath:)]) {
        [self.delegate CCW_MyAlertSheetView:self didSelectRowAtIndexPath:indexPath];
    }
    [tableView reloadData];
    [self CCW_CloseCompletion:nil];
}
@end
