//
//  CCWSearchDAppViewController.m
//  CocosBCXWallet
//
//  Created by SYLing on 2018/8/16.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSearchDAppViewController.h"
#import "CCWDappViewController.h"
#import "CCWDappModel.h"

@interface CCWSearchDAppViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation CCWSearchDAppViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipLabel.text = CCWLocalizable(@"在地址栏输入你想玩的DApp网址\n进入即可试玩");
    self.title = CCWLocalizable(@"搜索DApp");
    self.searchTextField.layer.cornerRadius = 2;
    self.searchTextField.layer.borderColor = [UIColor getColor:@"f0f2f3"].CGColor;
    self.searchTextField.layer.borderWidth = 0.5;
    self.searchTextField.text = @"http://gas.test.cocosbcx.net/";
}

- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
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
    CCWDappViewController *dappVC = [[CCWDappViewController alloc] initWithTitle:title loadDappURLString:urlStr];
    [self.navigationController pushViewController:dappVC animated:YES];
}

@end
