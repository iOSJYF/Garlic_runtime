//
//  BeeFollowViewController.h
//  Runtime_Use
//
//  Created by dryen siu on 16/7/27.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BeeBlock)(NSInteger index);

@interface BeeFollowViewController : UIViewController

@property (nonatomic,copy)BeeBlock beeBlock;

- (void)followAction:(NSInteger) num;


@end
