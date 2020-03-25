//
//  ViewController.m
//  object_getClass
//
//  Created by banma-1118 on 2019/9/23.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) Person *per1;
@property (nonatomic, strong) Person *per2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 每个实例对象开辟单独的内存
    // 同一种类对象仅在内存中开辟一次, 类名.class == object_getClass(对象)
    
    self.per1 = [[Person alloc] init]; // <Person: 0x600001ddefa0>          p/x self.per1->isa: A
    self.per2 = [[Person alloc] init]; // <Person: 0x600001ddef90>          p/x self.per2->isa: A
    
    Class perClass1 = [self.per1 class];    //  A
    Class perGetClass2 = object_getClass(self.per1);  // A
    Class person = [Person class]; // A
    
    Class perMeta2 = object_getClass(Person.class); // B  通过类对象获取元类对象
    Class clszz1 = [perClass1 class]; // A
    Class clazz2 = [perGetClass2 class]; // A
    
    // struct lyb_objc_class *perGetClass3 = (__bridge struct lyb_objc_class *)object_getClass(self.per1);
    struct lyb_objc_class *perGetClass3 = (__bridge struct lyb_objc_class *)Person.class;
    // p/x perGetClass3->isa: B
    
    struct lyb_objc_class *perMeta3 = (__bridge struct lyb_objc_class *)object_getClass(Person.class);  // Person.class的元类对象
    // p/x perMeta3->isa: 0x0000000105ec4e78
    Class rootMeta1 = [perMeta2 class]; // B 元类对象 Person  class返回的依然是元类对象自身
    // 基类(NSObject)的元类对象
    Class rootMeta2 = object_getClass(perMeta2); // NSObject 0x0000000105ec4e78 object_getClass返回的是基类的元类对象
    
    NSLog(@"Hello World!");
}

struct lyb_objc_class {
    Class _Nonnull isa;
};

// 系统的Class的isa没有暴露出来：
/**
struct objc_class {
    Class _Nonull isa OBJC_ISA_AVAILABILITY;
    ...
}
*/

@end
