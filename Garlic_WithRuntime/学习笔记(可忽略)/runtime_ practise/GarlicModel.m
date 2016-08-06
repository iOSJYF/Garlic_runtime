//
//  GarlicModel.m
//  runtime_ practise
//
//  Created by dryen siu on 16/7/25.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//

#import "GarlicModel.h"
#import <objc/runtime.h>

@implementation GarlicModel

/**
 *  我们可以使用runtime获取GarlicModel的属性列表再遍历出来
 */



- (void)encodeWithCorder
{
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([GarlicModel class], &count);
    for (int i = 0; i < count; i++) {
        // 取出i对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        // 设置到成员变量上
        [self setValue:value forKey:key];
    }
    free(ivars);
}


//
//
////    id objc = [[self alloc] init];
//    
//    unsigned int count = 0;
//    NSDictionary *dict = [[NSDictionary alloc]init];
//    
//    // 1.获取成员属性数组
//    Ivar *ivarList = class_copyIvarList(self, &count);
//    
//    // 2.遍历所有的成员属性名,一个一个去字典中取出对应的value给模型属性赋值
//    for (int i = 0; i < count; i++) {
//        
//        // 2.1 获取成员属性
//        Ivar ivar = ivarList[i];
//        
//        // 2.2 获取成员属性名 C -> OC 字符串
//        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        
//        // 2.3 _成员属性名 => 字典key
//        NSString *key = [ivarName substringFromIndex:1];
//        
//        // 2.4 去字典中取出对应value给模型属性赋值
//        id value = dict[key];
//        
//        // 获取成员属性类型
//        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
//        
//        // **********************************************************
//        
//        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType containsString:@"NS"]) {
//            
//            //  是字典对象,并且属性名对应类型是自定义类型
//            // 处理类型字符串 @\"User\" -> User
//            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
//            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            // 自定义对象,并且值是字典
//            // value:user字典 -> User模型
//            // 获取模型(user)类对象
//            Class modalClass = NSClassFromString(ivarType);
//            
//            
//            
//            
//            
//            // 字典转模型
//            if (modalClass) {
//                // 字典转模型 user
//                value = [modalClass objectWithDict:value];
//            }
//            
//        }
//        
//        if ([value isKindOfClass:[NSArray class]]) {
//            // 判断对应类有没有实现字典数组转模型数组的协议
//            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
//                
//                // 转换成id类型，就能调用任何对象的方法
//                id idSelf = self;
//                
//                // 获取数组中字典对应的模型
//                NSString *type =  [idSelf arrayContainModelClass][key];
//                
//                // 生成模型
//                Class classModel = NSClassFromString(type);
//                NSMutableArray *arrM = [NSMutableArray array];
//                // 遍历字典数组，生成模型数组
//                for (NSDictionary *dict in value) {
//                    // 字典转模型
//                    id model =  [classModel objectWithDict:dict];
//                    [arrM addObject:model];
//                }
//                
//                // 把模型数组赋值给value
//                value = arrM;
//                
//            }
//        }
//
//        
//    }
//    
//    
//    
//}


- (id)initWithCorder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([GarlicModel class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            key = [key substringFromIndex:1];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}



//+ (instancetype)modelWithDict:(NSDictionary *)dict
//{
//    // 思路：遍历模型中所有属性-》使用运行时
//    
//    // 0.创建对应的对象
//    id objc = [[self alloc] init];
//    
//    // 1.利用runtime给对象中的成员属性赋值
//    
//    // class_copyIvarList:获取类中的所有成员属性
//    // Ivar：成员属性的意思
//    // 第一个参数：表示获取哪个类中的成员属性
//    // 第二个参数：表示这个类有多少成员属性，传入一个Int变量地址，会自动给这个变量赋值
//    // 返回值Ivar *：指的是一个ivar数组，会把所有成员属性放在一个数组中，通过返回的数组就能全部获取到。
//    /* 类似下面这种写法
//     
//     Ivar ivar;
//     Ivar ivar1;
//     Ivar ivar2;
//     // 定义一个ivar的数组a
//     Ivar a[] = {ivar,ivar1,ivar2};
//     
//     // 用一个Ivar *指针指向数组第一个元素
//     Ivar *ivarList = a;
//     
//     // 根据指针访问数组第一个元素
//     ivarList[0];
//     
//     */
//    unsigned int count;
//    
//    // 获取类中的所有成员属性
//    Ivar *ivarList = class_copyIvarList(self, &count);
//    
//    for (int i = 0; i < count; i++) {
//        // 根据角标，从数组取出对应的成员属性
//        Ivar ivar = ivarList[i];
//        
//        // 获取成员属性名
//        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        
//        // 处理成员属性名->字典中的key
//        // 从第一个角标开始截取
//        NSString *key = [name substringFromIndex:1];
//        
//        // 根据成员属性名去字典中查找对应的value
//        id value = dict[key];
//        if (value) {
//            [objc setValue:value forKey:key];
//
//        }
//        
//        // 二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
//        // 判断下value是否是字典
//        if ([objc isKindOfClass:[NSDictionary class]]) {
//            // 字典转模型
//            // 获取模型的类对象，调用modelWithDict
//            // 模型的类名已知，就是成员属性的类型
//            
//            // 获取成员属性类型
//            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
//            // 生成的是这种@"@\"User\"" 类型 -》 @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
//            // 裁剪类型字符串
//            NSRange range = [type rangeOfString:@"\""];
//            
//            type = [type substringFromIndex:range.location + range.length];
//            
//            range = [type rangeOfString:@"\""];
//            
//            // 裁剪到哪个角标，不包括当前角标
//            type = [type substringToIndex:range.location];
//            
//            
//            // 根据字符串类名生成类对象
//            Class modelClass = NSClassFromString(type);
//            
//            
//            if (modelClass) { // 有对应的模型才需要转
//                
//                // 把字典转模型
//                value  =  [modelClass modelWithDict:value];
//            }
//            
//            
//        }
//        
////        // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
////        // 判断值是否是数组
////        if ([value isKindOfClass:[NSArray class]]) {
////            // 判断对应类有没有实现字典数组转模型数组的协议
////            if ([self respondsToSelector:@selector(eat)]) {
////                
////                // 转换成id类型，就能调用任何对象的方法
////                id idSelf = self;
////                
////                // 获取数组中字典对应的模型
////                NSString *type = [[self class] modelWithDict:dict];
////                
////                // 生成模型
////                Class classModel = NSClassFromString(type);
////                NSMutableArray *arrM = [NSMutableArray array];
////                // 遍历字典数组，生成模型数组
////                for (NSDictionary *dict in value) {
////                    // 字典转模型
////                    id model =  [classModel modelWithDict:dict];
////                    [arrM addObject:model];
////                }
////                
////                // 把模型数组赋值给value
////                value = arrM;
////                
////            }
////        }
////        
////        
////        if (value) { // 有值，才需要给模型的属性赋值
////            // 利用KVC给模型中的属性赋值
////            [objc setValue:value forKey:key];
////        }
////        
//    }
//    
//    return objc;
//}

//+ (instancetype)statusWithDict:(NSDictionary *)dict
//{
//    GarlicModel *status = [[self alloc] init];
//    
//    [status initWithCorder:dict];
//    
//    return status;
//    
//}

+ (id)eat:(NSDictionary *)dict
{
    NSLog(@"JiYuFeng");
    NSArray *thedictArray = dict.allKeys;
    
    return thedictArray;
    
}



@end
