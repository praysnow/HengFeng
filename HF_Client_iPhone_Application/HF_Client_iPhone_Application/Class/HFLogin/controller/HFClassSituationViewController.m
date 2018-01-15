//
//  HFClassSituationViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/9.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFClassSituationViewController.h"
#import <WebKit/WebKit.h>
#import "HFNetwork.h"

@interface HFClassSituationViewController ()<WKNavigationDelegate>

@property(strong,nonatomic)WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation HFClassSituationViewController

#pragma mark - lazy
- (WKWebView *)webView
{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view insertSubview:_webView belowSubview:self.progressView];
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, 2)];
        self.progressView.tintColor = [UIColor greenColor];
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"班级学情";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//
    
    NSString *urlString = [NSString stringWithFormat:@"%@/Exam/EXAM2_XueQingBanJiDetail.aspx?banJiID=%@",[HFNetwork network].ServerAddress,[HFCacheObject shardence].classId];
    
    NSLog(@"%@",urlString);
    
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
