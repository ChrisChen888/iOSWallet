//
//  CCWAddNodeViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/6/3.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWAddNodeViewController.h"
#import "CCWDataBase+CCWNodeINfo.h"

@interface CCWAddNodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *chainidTextField;
@property (weak, nonatomic) IBOutlet UITextField *fautcetTextField;
@property (weak, nonatomic) IBOutlet UITextField *assetTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *mainNetButton;

@property (nonatomic, weak) UIButton *selectButton;
@end

@implementation CCWAddNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = CCWLocalizable(@"自定义节点");
    self.selectButton = self.testButton;
}

- (IBAction)selectTypeClick:(UIButton *)sender {

    if (sender == self.selectButton) {
        return;
    }
    self.selectButton.selected = NO;
    sender.selected = YES;
    self.selectButton = sender;
}

- (IBAction)addButtonClick:(UIButton *)sender {

    if (IsStrEmpty(_nodeTextField.text)) {
        [self.view makeToast:CCWLocalizable(@"请输入Node")];
        return;
    }
    if (IsStrEmpty(_chainidTextField.text)) {
        [self.view makeToast:CCWLocalizable(@"请输入ChainId")];
        return;
    }
    if (IsStrEmpty(_fautcetTextField.text)) {
        [self.view makeToast:CCWLocalizable(@"请输入FaucetUrl")];
        return;
    }
    if (IsStrEmpty(_assetTextField.text)) {
        [self.view makeToast:CCWLocalizable(@"请输入Asset")];
        return;
    }
    if (IsStrEmpty(_nameTextField.text)) {
        [self.view makeToast:CCWLocalizable(@"请输入节点命名")];
        return;
    }
    sender.enabled = NO;
    CCWNodeInfoModel *nodeInfo = [[CCWNodeInfoModel alloc] init];
    nodeInfo.name = _nameTextField.text;
    nodeInfo.chainId = _chainidTextField.text;
    nodeInfo.coreAsset = _assetTextField.text;
    nodeInfo.faucetUrl = _fautcetTextField.text;
    if (self.selectButton.tag) {
        nodeInfo.type = YES;
    }else{
        nodeInfo.type = NO;
    }
    nodeInfo.ws = _nodeTextField.text;
    nodeInfo.isSelfSave = YES;
    
    NSMutableArray *nodeArray = [[CCWDataBase CCW_shareDatabase] CCW_QueryNodeInfo];
    CCWWeakSelf
    [nodeArray enumerateObjectsUsingBlock:^(CCWNodeInfoModel *  _Nonnull nodeinfoModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([nodeinfoModel.ws isEqualToString:nodeInfo.ws]) {
            [self.view makeToast:CCWLocalizable(@"此节点已存在")];
            *stop = YES;
            return;
        }
        
        if (idx + 1 == nodeArray.count) {
            // 刷新
            [[CCWDataBase CCW_shareDatabase] CCW_SaveNodeInfo:nodeInfo];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}


@end
