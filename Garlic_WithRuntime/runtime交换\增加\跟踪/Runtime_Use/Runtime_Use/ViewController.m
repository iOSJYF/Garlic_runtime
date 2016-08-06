//
//  ViewController.m
//  Runtime_Use
//
//  Created by dryen siu on 16/7/27.
//  Copyright © 2016年 蜜蜂. All rights reserved.
//

#import "ViewController.h"
#import "BeeWebViewController.h"
#import "BeeChangeMethodViewController.h"
#import "BeeFollowViewController.h"

#import <objc/runtime.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UIButton *imageButton;
@property (nonatomic,retain)BeeWebViewController *beeVC;
@property (nonatomic,retain)UISwitch *theSwitch;

@property (nonatomic,assign)NSInteger Ji;
@property (nonatomic,retain)UILabel *beeTitleLabel;

@end

@implementation ViewController

#pragma mark - ViewController 会优先走这个方法,所以我们把交换方法和跟踪方法定义在这个方法里面
+ (void)load
{
    // **************************** 动态交换两个方法的实现 ***************************************
    
    BeeChangeMethodViewController *beeChangeVC = [[BeeChangeMethodViewController alloc]init];
    Class PersionClass = object_getClass([beeChangeVC class]);
    Class toolClass = object_getClass([self class]);
    
    //源方法的SEL和Method   注意不要把selector里面的方法名写错
    SEL oriSEL = @selector(beeChange_method);
    Method oriMethod = class_getInstanceMethod(PersionClass, oriSEL);
    
    //交换方法的SEL和Method
    SEL cusSEL = @selector(view_method);
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



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /**
        除了之前的获取成员属性,runtime还可以获取方法列表和协议列表
    */
    
#pragma mark - 获取方法列表(即使是没执行的方法也能获取)
    unsigned int count;
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"ViewController 的方法有:%@", NSStringFromSelector(method_getName(method)));
    }
    
#pragma mark - 获取协议列表
    // * 这里我们写上tableview的协议
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"ViewController 的协议有%@", [NSString stringWithUTF8String:protocolName]);
    }

    /**
     *  首先看一个比较简单的,动态增加方法
     */
    // 动态添加方法
    [self add_method];
    
#pragma -------------------    分割线    --------------------------------
    self.title = @"点击图片进行跳转";
    
    self.imageButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-70, 100, 140, 140)];
    [self.imageButton setImage:[UIImage imageNamed:@"baidu.png"] forState:0];
    [self.imageButton addTarget:self action:@selector(pushToWeb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.imageButton];
    
    
    /**
     * runtime里还有一个交换方法,这里我们创建一个类,在类里面写一个方法替换了ViewController已经存在的方法
     这里有个example,我们交换BeeSwitchAction的方法,设置跳到youku网址
     */
    // *设置一个开关,打开是进行交换方法跳转到youku
    UISwitch *BeeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth/2-25, 250, 50, 30)];
    [BeeSwitch setOn:NO];
    [BeeSwitch addTarget:self action:@selector(BeeSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:BeeSwitch];
    
    UILabel *beeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 290, 200, 20)];
    beeTitleLabel.textAlignment = 1;
    beeTitleLabel.text = @"打开开关执行交换方法";
    [self.view addSubview:beeTitleLabel];
    
}


#pragma mark - 动态增加方法
- (void)add_method
{
    /**
     (IMP)guessAnswer 意思是guessAnswer的地址指针,所以增加的方法需要用runtime函数写;
     "v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
     “v@:@@” 意思是，两个参数的没有返回值。
     自己定义一个方法,我这里是myNewMethod,因为runtime里没有这个方法,则创建这个方法
     [self class]可以替换为其他的类
     */
    class_addMethod([self class], @selector(myNewMethod), (IMP)myNewMethod, "v@:");
    if ([self respondsToSelector:@selector(myNewMethod)]) {
        
        [self performSelector:@selector(myNewMethod)];
        
    } else{
        NSLog(@"Sorry,I don't know");
    }
}

// 这里是增加的方法
void myNewMethod(id self,SEL _cmd){
    NSLog(@"I am from GuangZhou");
}


// -----------------------    分割线    --------------------------------

#pragma mark - 开关方法
- (void)BeeSwitchAction:(id)sender
{
    _theSwitch = (UISwitch *)sender;
    if ([_theSwitch isOn]) {
        NSLog(@"on");
        [self.imageButton setImage:[UIImage imageNamed:@"youku.png"] forState:0];
    }else{
        NSLog(@"off");
        [self.imageButton setImage:[UIImage imageNamed:@"baidu.png"] forState:0];
        
    }
    
}

#pragma mark - 跳转到BeeWebViewController (我们在BeeChangeMethodVC里面定义一个方法替代这个方法)
#pragma 注意:如果是在别的类中定义方法来代替,则必须是类方法;如果是在同一个类中,则可以有私有方法
- (void)pushToWeb
{
    
// -----------      执行交换方法      -------------
    _beeVC = [[BeeWebViewController alloc]init];
    if ([_theSwitch isOn]) {
        _beeVC.garlicUrl = [[self class] view_method]; //这里两个方法已经调换
    }else{
        _beeVC.garlicUrl = [BeeChangeMethodViewController beeChange_method];
    }
    [self.navigationController pushViewController:_beeVC animated:YES];
    

// -----------      执行跟踪方法      -------------
    // 执行跟踪方法
    [self mySendAction:@selector(followAction:) to:self forEvent:UIEventTypeTouches];
        
}

// 和BeeChangeMethodVC交换的方法
+ (NSString *)view_method
{
    NSString *baiduString = @"http://www.baidu.com";
    return baiduString;
}
// 交换方法,感觉用的不多


#pragma mark - 跟踪方法
/**
 *  跟交换方法一样,跟踪方法也需要在load方法里定义;
    当我们想要对一个方法在其原有的功能上增加功能,如果不想去实例化,或者说实现了很多点击方法不确定是哪一个,那我们可以通过runtime,在不碰源代码的基础上进行代码添加
 */
// 跟踪方法
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    BeeFollowViewController *followVC = [[BeeFollowViewController alloc]init];
    followVC.beeBlock = ^(NSInteger num){
        _Ji = num;
        NSLog(@"num = %ld",_Ji);
        if (!_beeTitleLabel) {
            _beeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, ScreenWidth, 30)];
            _beeTitleLabel.textAlignment = 1;
            [self.view addSubview:_beeTitleLabel];
        }
        _beeTitleLabel.text = [NSString stringWithFormat:@"你已经跳转过%ld次",_Ji];

    };
    [followVC followAction:_Ji];
}






@end

