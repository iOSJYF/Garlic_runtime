//
//  GarlicViewController.h
//  runtime_ practise
//
//  Created by dryen siu on 16/7/23.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GarlicViewController : UIViewController

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger age;

#pragma mark - 交换方法
+ (void)garlic_method;

#pragma mark - 跟踪方法
- (void)addClickCount;

@end

