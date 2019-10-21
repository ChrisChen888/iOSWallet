//
//  CCWTermsViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/5/20.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWTermsViewController.h"

@interface CCWTermsViewController ()<UIWebViewDelegate>
/** <#视图#> */
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation CCWTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = CCWLocalizable(@"服务条款");
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"Terms of Service" ofType:@"html"];
    NSURL *TermsUrl = [NSURL fileURLWithPath:bundleStr];
    [webView loadRequest:[NSURLRequest requestWithURL:TermsUrl]];
    [self.view addSubview:webView];
    self.webView = webView;
}

@end
