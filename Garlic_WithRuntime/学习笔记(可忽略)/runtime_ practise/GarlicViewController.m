//
//  GarlicViewController.m
//  runtime_ practise
//
//  Created by dryen siu on 16/7/23.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import "GarlicViewController.h"

@interface GarlicViewController ()

@end

@implementation GarlicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.age = 18;
    
}

#pragma mark - 交换方法
+ (void)garlic_method
{
    NSLog(@"I'm garlic's method~");
}

#pragma mark - 跟踪方法
- (void)addClickCount
{
    NSLog(@"跟踪到点击了按钮");
    
}





@end
