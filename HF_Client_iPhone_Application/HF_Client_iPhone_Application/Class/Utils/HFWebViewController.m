//
//  HFWebViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 18/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFWebViewController.h"

@interface HFWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HFWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showBackButton];
    
    [self.webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: self.url] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 0]];
    [self scrollViewPanGestureRecognizerRequireScreenEdgePanGestureRecognizerToFail: self.webView.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
