//
//  BeeFollowViewController.m
//  Runtime_Use
//
//  Created by dryen siu on 16/7/27.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "BeeFollowViewController.h"

@interface BeeFollowViewController ()

//@property (nonatomic,assign)NSInteger num;

@end

@implementation BeeFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)followAction:(NSInteger) num
{
    NSLog(@"点进去了");
    num ++;
    self.beeBlock(num);
    
}



@end
