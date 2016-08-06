//
//  MyJsonModel.h
//  runtime_ practise
//
//  Created by dryen siu on 16/7/26.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJsonModel : NSObject

@property (nonatomic,copy)NSString *sta;
@property (nonatomic,copy)NSString *stb;
@property (nonatomic,copy)NSString *stc;
@property (nonatomic,copy)NSString *std;
@property (nonatomic,copy)NSString *ste;
@property (nonatomic,copy)NSString *stf;
@property (nonatomic,copy)NSString *stg;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
