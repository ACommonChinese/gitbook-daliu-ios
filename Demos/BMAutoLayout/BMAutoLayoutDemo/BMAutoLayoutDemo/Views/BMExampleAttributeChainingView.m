//
//  BMExampleAttributeChainingView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleAttributeChainingView.h"
#import <BMAutoLayout/BMAutoLayout.h>

@implementation BMExampleAttributeChainingView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *greenView = UIView.new;
    greenView.backgroundColor = UIColor.greenColor;
    greenView.layer.borderColor = UIColor.blackColor.CGColor;
    greenView.layer.borderWidth = 2;
    [self addSubview:greenView];
    
    UIView *redView = UIView.new;
    redView.backgroundColor = UIColor.redColor;
    redView.layer.borderColor = UIColor.blackColor.CGColor;
    redView.layer.borderWidth = 2;
    [self addSubview:redView];
    
    UIView *blueView = UIView.new;
    blueView.backgroundColor = UIColor.blueColor;
    blueView.layer.borderColor = UIColor.blackColor.CGColor;
    blueView.layer.borderWidth = 2;
    [self addSubview:blueView];
    
    UIView *superview = self;
    UIEdgeInsets padding = UIEdgeInsetsMake(15, 10, 15, 10);
    
    [greenView bm_makeConstraints:^(BMConstraintMaker *make) {
        // chain attributes
        make.top.left.equalTo(superview).insets(padding);
        
        // which is the equivalent of
        //        make.top.greaterThanOrEqualTo(superview).insets(padding);
        //        make.left.greaterThanOrEqualTo(superview).insets(padding);
        
        make.bottom.equalTo(blueView.topAnchor).insets(padding);
        make.right.equalTo(redView.leftAnchor).insets(padding);
        make.width.equalTo(redView.widthAnchor);
        
//        make.height.equalTo(redView);
//        make.height.equalTo(blueView);
        make.height.equalTo(@[redView, blueView]);
    }];
    
    [redView bm_makeConstraints:^(BMConstraintMaker *make) {
        // chain attributes
        make.top.right.equalTo(superview).insets(padding);
        
        make.left.equalTo(greenView.rightAnchor).insets(padding);
        make.bottom.equalTo(blueView.topAnchor).insets(padding);
        make.width.equalTo(greenView.widthAnchor);
        
//        make.height.equalTo(greenView);
//        make.height.equalTo(blueView);
        make.height.equalTo(@[greenView, blueView]);
    }];
    
    [blueView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.equalTo(greenView.bottomAnchor).insets(padding);
        
        // chain attributes
        make.left.right.bottom.equalTo(superview).insets(padding);
        
//        make.height.equalTo(greenView);
//        make.height.equalTo(redView);
        make.height.equalTo(@[greenView, redView]);
    }];
    
    return self;
}

@end
