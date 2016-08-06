//
//  MyJsonModel.m
//  runtime_ practise
//
//  Created by dryen siu on 16/7/26.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import "MyJsonModel.h"
#import <objc/runtime.h>

@implementation MyJsonModel

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    // 创建对应模型对象
    id objc = [[self alloc] init];
    
    unsigned int count = 0;
    
    // 1.获取成员属性数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    // 2.遍历所有的成员属性名,一个一个去字典中取出对应的value给模型属性赋值
    for (int i = 0; i < count; i++) {
        
        // 2.1 获取成员属性
        Ivar ivar = ivarList[i];
        
        // 2.2 获取成员属性名 C -> OC 字符串
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 2.3 _成员属性名 => 字典key
        NSString *key = [ivarName substringFromIndex:1];
        
        // 2.4 去字典中取出对应value给模型属性赋值
        id value = dict[key];
        
        // 获取成员属性类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
//        NSLog(@"key = %@, value = %@, ivartype = %@ anddic = %@",key,value,ivarType,dict);
        
        if (value) {
            NSLog(@"value = %@,key = %@",value,key);
            [objc setValue:value forKey:key];
        }
        
        
        //*********************
        //判断如果model里有字典
        if ([value isKindOfClass:[NSDictionary class]] && [ivarType containsString:@"NS"]) {
            
            //  是字典对象,并且属性名对应类型是自定义类型
            // 处理类型字符串 @\"User\" -> User
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            // 自定义对象,并且值是字典
            // value:user字典 -> User模型
            // 获取模型(user)类对象
            Class modalClass = NSClassFromString(ivarType);
            
            // 字典转模型
            if (modalClass) {
                
                [objc objectWithDict:value and:objc];
                
            }
            
        }
        //*********************
        //判断如果model有数组
        if ([value isKindOfClass:[NSArray class]] && [ivarType containsString:@"NS"]){

            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class modalClass = NSClassFromString(ivarType);
            if (modalClass) {
                [objc objectWithArray:value and:objc];
            }
        }
     
    }
    return objc;
}


- (void)objectWithDict:(NSDictionary *)dict and:(id)objc
{
    
    unsigned int count = 0;
    
    // 1.获取成员属性数组
    Ivar *ivarList = class_copyIvarList([MyJsonModel class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivarList[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        key = [key substringFromIndex:1];
        
        id value = dict[key];

        // 设置到成员变量身上
        if (value) {
            [objc setValue:value forKey:key];
        }
    }

    
}

- (void)objectWithArray:(NSArray *)array and:(id)objc
{
    for (int a = 0; a < array.count; a ++) {
        unsigned int count = 0;
        
        NSDictionary *dict = array[a];
        
        // 1.获取成员属性数组
        Ivar *ivarList = class_copyIvarList([MyJsonModel class], &count);
        
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivarList[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            key = [key substringFromIndex:1];
            
            id value = dict[key];
            
            // 设置到成员变量身上
            if (value) {
                [objc setValue:value forKey:key];
            }
        }
    }
}



@end
