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

@end
