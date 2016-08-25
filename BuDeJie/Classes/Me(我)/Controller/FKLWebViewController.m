//
//  FKLWebViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLWebViewController.h"
#import <WebKit/WebKit.h>
@interface FKLWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBarItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation FKLWebViewController
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加webView
    WKWebView *webView = [[WKWebView alloc] init];
    [self.contentView addSubview:webView];
    self.webView = webView;
    // 展示网页
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    // KVO监听属性变化,KVO要移除
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
// 主要观察对象属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.backBarItem.enabled = self.webView.canGoBack;
    self.forwardBarItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.contentView.bounds;
}
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
