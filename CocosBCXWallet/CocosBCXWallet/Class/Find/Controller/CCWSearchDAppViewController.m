//
//  CCWSearchDAppViewController.m
//  CocosBCXWallet
//
//  Created by SYLing on 2018/8/16.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSearchDAppViewController.h"
#import "CCWDappViewController.h"
#import "CCWDataBase+CCWFindDapp.h"


#import "CCWMyDappCollectionViewCell.h"

//#import "CCWDappCollectionReusableView.h"
//
///* cell缓存池标示 */
static NSString * const collectionViewCell = @"CCWMyDappCollectionViewCell";
///* 分组头部视图的缓存池标示 */
//static NSString * const CCWDappReusableViewIdentifier = @"CCWDappReusableViewIdentifier";
//
///* 分组头部视图的标示 */
//static NSString * const CCWDappGroupTitleHistory = @"最近访问DApp";
//
///* 分组头部视图的标示 */
//static NSString * const CCWDappGroupTitleFollow = @"我的收藏";

@interface CCWSearchDAppViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CCWDappCellDelegate>
{
    // 编辑状态
    BOOL _cellEdit;
}

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

/** 视图 */
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataDAppSource;

@end

@implementation CCWSearchDAppViewController

- (NSMutableArray *)dataDAppSource
{
    if (!_dataDAppSource) {
        _dataDAppSource = [NSMutableArray array];
    }
    return _dataDAppSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CCWLocalizable(@"搜索DApp");
    self.searchTextField.layer.cornerRadius = 2;
    self.searchTextField.layer.borderColor = [UIColor getColor:@"f0f2f3"].CGColor;
    self.searchTextField.layer.borderWidth = 0.5;
    //    self.tipLabel.text = CCWLocalizable(@"在地址栏输入你想玩的DApp网址\n进入即可试玩");
    _cellEdit = NO;
    
    
    // collectionView
    [self setCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataDAppSource = [[CCWDataBase CCW_shareDatabase] CCW_QueryMyOpenedDappArray].mutableCopy;
    
}

- (void)setCollectionView {

    // collectionView 的布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置cell尺寸
    CGFloat magin = 12;
    CGFloat itemSizeWH = (CCWScreenW - 30 - magin * 5)/4;
    flowLayout.itemSize = CGSizeMake(itemSizeWH, itemSizeWH);
    // 内容四边距
    flowLayout.sectionInset = UIEdgeInsetsMake(magin, magin, magin, magin);
    // 设置水平排版cell
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 设置cell的间距
    //cell间距
    flowLayout.minimumInteritemSpacing = magin;
    flowLayout.minimumLineSpacing = magin;
    
    [self.collectionView registerNib:[UINib nibWithNibName:collectionViewCell bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:collectionViewCell];
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataDAppSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCWMyDappCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCell forIndexPath:indexPath];
    cell.delegate = self;
    CCWDappModel *dappModel = self.dataDAppSource[indexPath.row];
    [cell dappModel:dappModel withDelete:_cellEdit];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CCWDappModel *dappModel = self.dataDAppSource[indexPath.row];
    [self pushFindLoadWebViewWithURLString:dappModel.linkUrl     title:dappModel.title];
}

#pragma mark - CCWDappCellDelegate
- (void)dappCollectionViewCellLongPressToEdit:(CCWMyDappCollectionViewCell *)dappCell
{
    _cellEdit = !_cellEdit;
    [self.collectionView reloadData];
}



- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
                NSLog(@"不支持的URL方案");
            }
        }
    }
    return returnUrlStr;
}

- (IBAction)searchUrl:(id)sender
{
    [self pushFindLoadWebViewWithURLString:self.searchTextField.text title:@"DApp"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pushFindLoadWebViewWithURLString:self.searchTextField.text title:@"DApp"];
}

#pragma mark - textFieldAction
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pushFindLoadWebViewWithURLString:textField.text title:@"DApp"];
    [textField endEditing:YES];
    return YES;
}

/** 跳转搜索加载WebView */
- (void)pushFindLoadWebViewWithURLString:(NSString *)urlString title:(NSString *)title {
    NSString *urlStr = [self getCompleteWebsite:urlString];
    if ([urlStr isEqualToString:@""] || !urlStr) {
        return;
    }
    CCWDappViewController *dappVC = [[CCWDappViewController alloc] initWithTitle:title loadDappURLString:urlStr dappDec:nil dappIcon:nil];
    [self.navigationController pushViewController:dappVC animated:YES];
}

@end
