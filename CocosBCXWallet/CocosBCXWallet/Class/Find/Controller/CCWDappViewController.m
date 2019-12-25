//
//  CCWDappViewController.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/27.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWDappViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+EmptyView.h"
#import "CCWDappWebTool.h"
#import "CCWNodeInfoModel.h"
#import "CCWPwdAlertView.h"

@interface CCWDappViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, copy) NSString *dappTitle;
@property (nonatomic, copy) NSString *dappURLString;
@property (nonatomic, strong) WKWebView *wkWebView;
/* 1.添加UIProgressView属性 */
@property (nonatomic, strong) UIProgressView *progressView;

// 临时密码
@property (nonatomic, copy) NSString *viewpassword;
@end

@implementation CCWDappViewController

- (instancetype)initWithTitle:(NSString *)dappTitle loadDappURLString:(NSString *)dappURLString
{
    if (self = [super init]) {
        _dappTitle = dappTitle;
        _dappURLString = dappURLString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self CCW_SetupView];
    
    NSString *urlString = self.dappURLString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 5.0f;
    [self.wkWebView loadRequest:request];

}

- (void)CCW_SetupView
{
    self.title = _dappTitle;
    /*
     *2.初始化progressView
     */
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, APP_Navgationbar_Height, CCWScreenW, 1)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //左边导航栏的图标
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStylePlain target:self action:@selector(CCW_GoBackAction)];
}

// 清除缓存
//- (void)dealloc
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    
    // 清理缓存
    [self clearWebCache];
}

- (void)clearWebCache {
    NSSet *websiteDataTypes = [NSSet setWithArray:@[
                            WKWebsiteDataTypeDiskCache,
                            WKWebsiteDataTypeMemoryCache
                            ]];
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
}

// 左侧返回按钮
- (void)CCW_GoBackAction
{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 监听
/*
 *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            CCWWeakSelf
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.wkWebView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
/*
 *5.在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条
 */
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    CCWLog(@"开始加载网页");
    CCWLog(@"%@",webView.URL);
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    CCWLog(@"加载完成");
    
    // 初始化节点
    CCWNodeInfoModel *saveNodelInfo = [CCWNodeInfoModel mj_objectWithKeyValues:CCWNodeInfo];
    NSString *jsStr = [NSString stringWithFormat:@"BcxWeb.initConnectClent('%@', '%@','%@','%@')",saveNodelInfo.ws, saveNodelInfo.coreAsset, saveNodelInfo.faucetUrl, saveNodelInfo.chainId];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:nil];
    
    //加载完成后隐藏progressView
    //    self.progressView.hidden = YES;
    [self.view configWithHasData:YES noDataImage:nil noDataTitle:nil hasError:NO reloadBlock:^(id sender) {
    }];
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    CCWLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    CCWWeakSelf
    [self.view configWithHasData:NO noDataImage:nil noDataTitle:nil hasError:YES reloadBlock:^(id sender) {
        [webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:weakSelf.dappURLString]]];
    }];
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    //    TWLog(@"%@",navigationAction.request.URL);
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKWKNavigationDelegate Methods
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"\n name:%@\n body:%@\n",message.name,message.body);
    if (![message.name isEqualToString:JS_PUSHMESSAGE]) {
        return;
    }
    
    NSDictionary *messagebody = message.body;
    
    // init 回调
    if ([messagebody[@"methodName"] isEqualToString:JS_METHOD_initConnect]) {
        NSString *jsString = [CCWNodeInfo mj_JSONString];
        jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
        return;
    }
    
    CCWWeakSelf;
    // 弹窗
    if ([self isVaildPasswordWithMessageBody:message.body]) {
        // 判断是否有密码保存
        if (self.viewpassword) {
            [CCWDappWebTool JSHandle_ReceiveMessageBody:messagebody password:self.viewpassword response:^(NSDictionary * _Nonnull response) {
                NSString *jsString = [response mj_JSONString];
                jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
            }];
        }else{
            CCWPwdAlertView *alert = [CCWPwdAlertView passwordAlertWithCancelClick:^{
                NSDictionary *message = @{
                                          @"type":@"signature_rejected",
                                          @"message":@"User rejected the signature request",
                                          @"code":@"402",
                                          @"isError":@1
                                          };
                [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"] andMessage:[message mj_JSONString]];
            } confirmClick:^(NSString *pwd, BOOL isIgnoreConfirm) {
                
                // 加一层验证密码的
                [CCWSDKRequest CCW_ValidateAccount:CCWAccountName password:pwd Success:^(id  _Nonnull responseObject) {
                    if (responseObject[@"active_key"]) {
                        if (isIgnoreConfirm) { // 是否记住密码
                            weakSelf.viewpassword = pwd;
                        }
                        [CCWDappWebTool JSHandle_ReceiveMessageBody:messagebody password:pwd response:^(NSDictionary * _Nonnull response) {
                            NSString *jsString = [response mj_JSONString];
                            jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                            [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
                        }];
                    }else{
                        NSDictionary *pwdError = @{
                                                   @"message":@"Please enter the correct original/temporary password",
                                                   @"code":@(105)
                                                   };
                        NSString *jsString = [pwdError mj_JSONString];
                        jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
                    }
                } Error:^(NSString * _Nonnull errorAlert, id  _Nonnull responseObject) {
                    NSDictionary *pwdError = @{
                             @"message":@"Please enter the correct original/temporary password",
                             @"code":@(105)
                             };
                    NSString *jsString = [pwdError mj_JSONString];
                    jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
                    [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
                }];
            }];
            [alert show];
        }
    }else{
        [CCWDappWebTool JSHandle_ReceiveMessageBody:messagebody password:nil response:^(NSDictionary * _Nonnull response) {
            NSString *jsString = [response mj_JSONString];
            jsString = [jsString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
            [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:messagebody[@"serialNumber"]  andMessage:jsString];
        }];
    }
}

#pragma mark - callbackResult
// pushMessageResultResponse callbackResult
- (void)responseToJsWithJSMethodName:(NSString *)jsMethodName SerialNumber:(NSString *)serialNumber andMessage:(NSString *)message{
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@', '%@')", jsMethodName,serialNumber, message];
    NSLog(@"responseToJs %@", jsStr);
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //        NSLog(@"%@----%@",result, error);
    }];
}

#pragma mark - 弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = userContentController;
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self getInjectJS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];// forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
        [userContentController addUserScript:userScript];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, APP_Navgationbar_Height, CCWScreenW, CCWScreenH - APP_Navgationbar_Height) configuration:configuration];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [_wkWebView.configuration.userContentController addScriptMessageHandler:self name:JS_PUSHMESSAGE];
        [self.view addSubview:_wkWebView];
        if (@available(iOS 9.0, *)) {
//            self.wkWebView.customUserAgent = @"iOS";
        } else {
            // Fallback on earlier versions
        }
    }
    return _wkWebView;
}


- (NSString *)getInjectJS {
    //compress_xinxin testScatterSONG
    NSString *JSfilePath = [[NSBundle mainBundle]pathForResource:@"cocos" ofType:@"js"];
    
    NSString *content = [NSString stringWithContentsOfFile:JSfilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *final = [@"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \""
                       stringByAppendingString:content];
    return final;
}


#pragma mark - 私有方法
// 过滤方法是否给提示窗，输入密码
- (BOOL)isVaildPasswordWithMessageBody:(NSDictionary *)body
{
    // 先过滤一遍
    if([body[@"methodName"] isEqualToString:JS_METHOD_transfer]) {
        return YES;
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_callContract]) {
        return YES;
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_decodeMemo]) {
        return YES;
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_transferNH]) {
        return YES;
    }else if([body[@"methodName"] isEqualToString:JS_METHOD_fillNHAssetOrder]) {
        return YES;
    }else if ([body[@"methodName"] isEqualToString:JS_METHOD_publishVotes]) {
        return YES;
    }else if ([body[@"methodName"] isEqualToString:JS_METHOD_claimVestingBalance]) {
        return YES;
    }else if ([body[@"methodName"] isEqualToString:JS_METHOD_updateCollateralForGas]) {
        return YES;
    }
    return NO;
}


// 获取网站域名
- (NSString *)getDappURLStringHost:(NSString *)dappURLString
{
    NSString *url = dappURLString;
    NSString *regexString = @"https?://(www\\.)?[0-9a-zA-Z]+(\\.[0-9a-zA-Z]+)+";
    NSRange range = [url rangeOfString:regexString options:NSRegularExpressionSearch];
    @try {
        NSString *urlHost = [url substringWithRange:range];
        return urlHost;
    } @catch (NSException *exception) {
        return nil;
    }
}

@end
