//
//  BMExampleConstantsView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleConstantsView.h"

@implementation BMExampleConstantsView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *purpleView = UIView.new;
    purpleView.backgroundColor = UIColor.purpleColor;
    purpleView.layer.borderColor = UIColor.blackColor.CGColor;
    purpleView.layer.borderWidth = 2;
    [self addSubview:purpleView];
    
    UIView *orangeView = UIView.new;
    orangeView.backgroundColor = UIColor.orangeColor;
    orangeView.layer.borderColor = UIColor.blackColor.CGColor;
    orangeView.layer.borderWidth = 2;
    [self addSubview:orangeView];
    
    //example of using constants
    
    [purpleView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.bottom.equalTo(@-20);
        make.right.equalTo(@-20);
    }];
    
    // auto-boxing macros allow you to simply use scalars and structs, they will be wrapped automatically
    
    [orangeView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(200, 100));
    }];
    
//    [orangeView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
//    [orangeView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:0].active = YES;
//
//    orangeView.centerXAnchor.constraint(self.xAnchor, 100).active(YES);
    
    return self;
}

@end
