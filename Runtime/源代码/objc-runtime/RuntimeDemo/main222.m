//
//  main.m
//  ObjcRuntime
//
//  Created by Chris on 2020/1/7.
//  Copyright © 2020 iEasyNote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/message.h>

@interface AAA : NSObject

@property (nonatomic, assign) long long l;

@property (nonatomic, assign) int a;

@property (nonatomic, assign) char b;

@property (nonatomic, assign) char c;

@end

@implementation AAA

@end

@interface BBB : NSObject

@property (nonatomic, assign) long long l;

@property (nonatomic, assign) char b;

@property (nonatomic, assign) int a;

@property (nonatomic, assign) char c;

@end

@implementation BBB

@end

@interface Person : NSObject

- (int)hands;

- (int)legs;

@property (nonatomic, copy) NSString *name;

@end

@implementation Person

- (int)hands {
    return 2;
}

- (int)legs {
    return 2;
}

- (NSString *)name {
    return NSStringFromClass([self class]);
}

@end

@interface Student : Person

@end

@implementation Student

@end

@interface Animal : NSObject

- (int)legs;

- (NSString *)name;

@end

@implementation Animal

//+ (BOOL)resolveClassMethod:(SEL)sel {
//    Method method = class_getClassMethod([self class], sel);
//    if (!method) {
//        NSLog(@"############### NNNN");
//        return NO;
//    }
//    NSLog(@"######### WWWWWW");
//    return [super resolveClassMethod:sel];
//}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(hands)) {
//        class_addMethod([self class], sel, dynamicMethodIMP, @"v@:");
//        NSLog(@"############### NNNN");
//        return YES;
//    }
//    NSLog(@"######### WWWWWW : %@", NSStringFromSelector(sel));
//    return [super resolveInstanceMethod:sel];
//}
//
//void dynamicMethodIMP(id self, SEL _cmd)
//{
//    // implementation ....
//    NSLog(@"########## Unrecognized selector: %@", NSStringFromSelector(_cmd));
//}

//- (void)doesNotRecognizeSelector:(SEL)aSelector {
//    @try {
//        [super doesNotRecognizeSelector:aSelector];
//    } @catch (NSException *exception) {
//        NSLog(@"########## exception: %@", exception);
//    } @finally {
//        NSLog(@"########## finally");
//    }
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(hands)) {
        return object_getClass(self);//[self class];//[Animal self];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (int)hands {
    return 1000;
}

- (NSString *)name {
    return NSStringFromClass([self class]);
}

- (int)legs {
    return 4;
}

@end

@interface Any : NSObject

+ (void)testAny;

- (void)eat;

@end

@implementation Any

+ (void)testAny {
    NSLog(@"######## Test Anay");
}

- (void)eat {
    NSLog(@"###### EAT");
}

@end

#pragma mark -

int main(int argc, char * argv[]) {
    // A & B
    {
        NSLog(@"########## sizeof a: %ld, sizeof b: %ld",
              class_getInstanceSize([AAA class]),
              class_getInstanceSize([BBB class]));
    }
    
    // Test
    {
        id obj1 = [NSMutableArray alloc];
         id obj2 = [[NSMutableArray alloc] init];

         id obj3 = [NSArray alloc];
         id obj4 = [[NSArray alloc] initWithObjects:@"Hello",nil];

         NSLog(@"obj1 class is %@",NSStringFromClass([obj1 class]));
         NSLog(@"obj2 class is %@",NSStringFromClass([obj2 class]));

         NSLog(@"obj3 class is %@",NSStringFromClass([obj3 class]));
         NSLog(@"obj4 class is %@",NSStringFromClass([obj4 class]));

         id obj5 = [Person alloc];
         id obj6 = [[Person alloc] init];

         NSLog(@"obj5 class is %@",NSStringFromClass([obj5 class]));
         NSLog(@"obj6 class is %@",NSStringFromClass([obj6 class]));
    }
    
    // Interact with NSObject
    {
        Student *student = [Student new];
        NSLog(@"######## NSObject student: %@", student);
        NSLog(@"######## NSObject student.name: %@", student.name);
        
        NSLog(@"######## STUDENT: %p, %p, %p %p",
              object_getClass(student), [student class], [Student class], [Student self]);
    }

    // Interact with runtime
    {
        id student = ((Student *(*)(id, SEL))(void *)objc_msgSend
                      )((id)objc_getClass("Student"), sel_registerName("new"));
        NSLog(@"######## Runtime student: %@", student);
        
        id name = ((NSString * (*)(id, SEL))(void *)objc_msgSend
                   )((id)student, sel_registerName("name"));
        NSLog(@"######## Runtime student.name: %@", name);

//        struct objc_class s;
//        struct objc_object o;
    }
    
    // Interact with imp
    {
        Class cls = objc_getClass("Student");
        SEL sel = sel_registerName("new");
        Method method = class_getClassMethod(cls, sel);
        IMP imp = method_getImplementation(method);
        id student = ((Student *(*)(id, SEL))imp)(cls, sel);
        NSLog(@"######### Student: %@", student);
        
        NSString *name = ((NSString * (*)(id, SEL))(void *)[student methodForSelector:@selector(name)])(student, @selector(name));
        NSLog(@"########## student.name: %@", name);
    }
    
    // Class pair
    {
        Class cls = objc_allocateClassPair([Student class], "Chris", 0);
//        SEL selector = @selector(hiehgt:);
//        Method method = class_getClassMethod(cls, selector);
//        IMP imp = method_getImplementation(method);
//        class_addMethod(cls, selector, imp, "v@:");
//        class_addMethod(cls, @selector(name), (IMP)added_method_implentation, "v@:");
        objc_registerClassPair(cls);
        
//        SEL sel = sel_registerName("new");
//        Method method = class_getClassMethod(cls, sel);
//        IMP imp = method_getImplementation(method);
//        id student = ((id (*)(id, SEL))imp)(cls, sel);
        id chris = [cls new];
        NSLog(@"######### Chris: %@", chris);
        NSLog(@"######### Christ.name: %@", [chris name]);
    }
    
    // Change isa at runtime
    {
        id person = [Any new];
        [person eat];
        
        object_setClass(person, [Person class]);
        
        NSLog(@"########### person.name: %@, hands: %d, legs: %d",
              [person name], [person hands], [person legs]);
        object_setClass(person, [Animal class]);
        NSLog(@"########### person.name: %@, hands:%d, legs: %d",
              [person name], [person hands], [person legs]);
        object_setClass(person, [Student class]);
        NSLog(@"########### person.name: %@, hands: %d, legs: %d",
              [person name], [person hands], [person legs]);
    }
    
    // Check
    {
        Student *student = [Student new];
        NSLog(@"########### student.isKindOfClass: %d", [student isKindOfClass:[NSObject class]]);
        NSLog(@"########### student.isKindOfClass: %d", [student isKindOfClass:[Person class]]);
        NSLog(@"########### student.isKindOfClass: %d", [student isKindOfClass:[Student class]]);
        NSLog(@"########### student.isMemberOfClass: %d", [student isMemberOfClass:[NSObject class]]);
        NSLog(@"########### student.isMemberOfClass: %d", [student isMemberOfClass:[Person class]]);
        NSLog(@"########### student.isMemberOfClass: %d", [student isMemberOfClass:[Student class]]);
    }

    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
