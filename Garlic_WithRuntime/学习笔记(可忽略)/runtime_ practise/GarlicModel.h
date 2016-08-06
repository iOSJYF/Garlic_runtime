//
//  GarlicModel.h
//  runtime_ practise
//
//  Created by dryen siu on 16/7/25.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol eatDelegate <NSObject>


@end

@interface GarlicModel : NSObject <eatDelegate>

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;
@property (nonatomic,copy) NSString *computer;
@property (nonatomic,assign) BOOL isMan;
@property (nonatomic,copy) NSString *hobby;
@property (nonatomic,copy) NSString *mac;

//+ (instancetype)modelWithDict:(NSDictionary *)dict;
//+ (instancetype)statusWithDict:(NSDictionary *)dict;
- (id)initWithCorder:(NSCoder *)decoder;


@end
