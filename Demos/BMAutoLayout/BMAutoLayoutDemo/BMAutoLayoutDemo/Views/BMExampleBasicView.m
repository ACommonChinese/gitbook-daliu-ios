//
//  BMExampleBasicView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleBasicView.h"

@implementation BMExampleBasicView

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
    int padding = 10;
    
    //if you want to use Masonry without the mas_ prefix
    //define MAS_SHORTHAND before importing Masonry.h see Masonry iOS Examples-Prefix.pch
    [greenView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(superview.topAnchor).offset(padding);
        make.left.equalTo(superview.leftAnchor).offset(padding);
        make.bottom.equalTo(blueView.topAnchor).offset(-padding);
        make.right.equalTo(redView.leftAnchor).offset(-padding);
        make.width.equalTo(redView.widthAnchor);
        make.height.equalTo(redView.heightAnchor);
        make.height.equalTo(blueView.heightAnchor);
    }];
    
    //with is semantic and option
    [redView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.equalTo(superview.topAnchor).offset(padding);
        make.left.equalTo(greenView.rightAnchor).offset(padding);
        make.bottom.equalTo(blueView.topAnchor).offset(-padding);
        make.right.equalTo(superview.rightAnchor).offset(-padding);
        make.width.equalTo(greenView.widthAnchor);
        make.height.equalTo(@[greenView, blueView]);
    }];
    
    [blueView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.equalTo(greenView.bottomAnchor).offset(padding);
        make.left.equalTo(superview.leftAnchor).offset(padding);
        make.bottom.equalTo(superview.safeAreaLayoutGuide.bottomAnchor).offset(-padding);
        make.right.equalTo(superview.rightAnchor).offset(-padding);
        make.height.equalTo(@[greenView.heightAnchor, redView.heightAnchor]);
    }];
    
    return self;
}

@end
