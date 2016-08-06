//
//  BeeWebViewController.m
//  Runtime_Use
//
//  Created by dryen siu on 16/7/27.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "BeeWebViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BeeWebViewController ()<UIWebViewDelegate>

@end

@implementation BeeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [webView setUserInteractionEnabled:YES];//是否支持交互
    webView.delegate=self;
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.garlicUrl]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}



@end
