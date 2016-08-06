//
//  ViewController.m
//  runtime_ practise
//
//  Created by Garlic on 16/7/23.
//  Copyright © 2016年 com.MiaoquDuoduo. All rights reserved.
//



// 参考网址:http://gcblog.github.io/2016/04/16/runtime详解/#more


#import "ViewController.h"
#import <objc/message.h>

#import "GarlicViewController.h"

#import "GarlicModel.h"

#import "MyJsonModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int member_variable; //成员变量
}
@property (nonatomic,copy) NSString *property1; //全局变量
@property (nonatomic,copy) NSString *property2; //全局变量

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    GarlicModel *mymodel = [[GarlicModel alloc]init]; //属性只能多于字典不能少于字典key
//    NSDictionary *myDic = @{@"name":@"Garlic",@"age":@18,@"computer":@{@"a":@"a",@"b":@"b"}};
//    [mymodel setValuesForKeysWithDictionary:myDic];
//    NSLog(@"name = %@, age = %@, mac = ",mymodel.name,mymodel.computer);
    
    
    NSDictionary *myJsonDic = @{@"sta":@"a",@"stb":@"b",@"stc":@"c",@"std":@"d",@"ste":@[@{@"stf":@"f"},@{@"stg":@"g"}]};

//    NSDictionary *myJsonDic = @{@"sta":@"a",@"stb":@"b",@"stc":@"c",@"std":@"d",@"ste":@{@"stf":@"f",@"stg":@"g"}};
    
    MyJsonModel *jsonmodel = [MyJsonModel modelWithDict:myJsonDic];
    NSLog(@"a = %@,b = %@",jsonmodel.sta,jsonmodel.stg);
    
    
    
    
#pragma mark - 获取属性列表
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
#pragma mark - 获取方法列表(无论有没有调用的都能获取的到)
    unsigned int count2;
    Method *methodList = class_copyMethodList([self class], &count2);
    for (unsigned int i=0; i<count2; i++) {
        Method method = methodList[i];
        NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
    }
    
#pragma mark - 获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
#pragma mark - 获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
    // 动态变量控制
    [self change_variable];

    // 动态添加方法
    [self add_method];
    
    
    // 动态交换两个方法的实现
    [[self class] tool_method];
    
    
    // 创建一个按钮让GarlicViewController能够跟踪记录改按钮的点击次数和频率等数据
    UIButton *garlicButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    garlicButton.backgroundColor = [UIColor yellowColor];
    [garlicButton addTarget:self action:@selector(garlicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:garlicButton];


    
}

#pragma mark - 通过动态变量控制修改GarlicController的age属性
- (void)change_variable{
    GarlicViewController *gar = [[GarlicViewController alloc]init];
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([gar class], &count);
    for (int i = 0; i<count; i++) {
        Ivar var = ivar[i];
        const char  *varName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:varName];
        if ([name isEqualToString:@"_age"]) {
            object_setIvar(gar, var, (__bridge id)((void *)20)); // 强转
            /**
             在这里也可以把Garlic.h的age设为nsnumber类型,则:
             object_setIvar(gar, var, @20);
             */
            break;
        }
    }
    
    NSLog(@"XiaoMing’s age is %ld",(long)gar.age);
}
#pragma mark - 动态增加方法
- (void)add_method
{
    /**
     (IMP)guessAnswer 意思是guessAnswer的地址指针;
     "v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
     “v@:@@” 意思是，两个参数的没有返回值。
     guess1 这个方法是假设runtime里面没有这个方法,然后自己自定义的一个方法,所以可以是随意的名字
     */
    GarlicViewController *gar = [[GarlicViewController alloc]init];
    class_addMethod([gar class], @selector(guess1), (IMP)guessAnswer, "v@:");
    if ([gar respondsToSelector:@selector(guess1)]) {
        
        [gar performSelector:@selector(guess1)];
        
    } else{
        NSLog(@"Sorry,I don't know");
    }
    
}

// 这里是增加的方法
void guessAnswer(id self,SEL _cmd){
    NSLog(@"I am from ShanTou");
}

#pragma mark - 1.动态交换两个方法的实现
#pragma mark - 2.跟踪记录APP中按钮的点击次数和频率等数据(在方法上增加额外的功能)
/**
 *  动态交换方法如果方法是介于类与类之间的交换,必须是类方法,如果是在同一个类里的则可以是私有方法
 */
+ (void)load //ViewController会优先走这个方法
{
    
// **************************** 动态交换两个方法的实现 ***************************************
    
    GarlicViewController *garlic = [[GarlicViewController alloc]init];
    Class PersionClass = object_getClass([garlic class]);
    Class toolClass = object_getClass([self class]);
    
    //源方法的SEL和Method
    SEL oriSEL = @selector(garlic_method);
    Method oriMethod = class_getInstanceMethod(PersionClass, oriSEL);
    
    //交换方法的SEL和Method
    SEL cusSEL = @selector(tool_method);
    Method cusMethod = class_getInstanceMethod(toolClass, cusSEL);
    
    //先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
    BOOL addSucc = class_addMethod(PersionClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod(toolClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        
    }else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    
// *******************************************************************

// ************* 跟踪记录APP中按钮的点击次数和频率等数据 ********************
    /**
     *  因为可能别人不一定会去实例化你的子类,或者其他类实现了点击方法不确定是哪一个,则可以通过runtime这个方法来解决
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(sendAction:to:forEvent:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(mySendAction:to:forEvent:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
        if (addSucc) {
            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            method_exchangeImplementations(oriMethod, cusMethod);
        }
        
    });
    
    
// *******************************************************************

    
}


// ViewController定义的方法,替换GarlicViewController的方法
+ (void)tool_method
{
    NSLog(@"I'm tool's method");
}

// 跟踪方法
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    GarlicViewController *garVC = [[GarlicViewController alloc]init];
    [garVC addClickCount];
}

- (void)garlicAction
{
    NSLog(@"我点击了一次按钮");
    // 执行跟踪方法
    [self mySendAction:@selector(garlicAction) to:self forEvent:UIEventTypeTouches];

}





@end
