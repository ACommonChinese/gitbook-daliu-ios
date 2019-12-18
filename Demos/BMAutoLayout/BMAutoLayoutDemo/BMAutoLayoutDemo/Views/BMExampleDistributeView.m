//
//  BMExampleDistributeView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleDistributeView.h"
#import <BMAutoLayout/BMAutoLayout.h>

@implementation BMExampleDistributeView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
//
//    UIView *testView = UIView.new;
//    testView.backgroundColor = [UIColor redColor];
//    [self addSubview:testView];
//
//    [testView bm_makeConstraints:^(BMConstraintMaker *make) {
//        make.width.equalTo(100);
//
//        make.right.equalTo(self).offset(-20);
//
//        make.top.equalTo(@60);
//        make.height.equalTo(@60);
//    }];
//
//    return self;
    
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < 4; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;

        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", (int)i];
        label.font = [UIFont systemFontOfSize:40];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];

        [label bm_makeConstraints:^(BMConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(0);
        }];
        
        [self addSubview:view];
        [arr addObject:view];
    }
    
    unsigned int type  = 3;//arc4random()%4;
    switch (type) {
        case 0: {
            [arr bm_distributeViewsAlongAxis:BMAxisTypeHorizontal withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
            [arr bm_makeConstraints:^(BMConstraintMaker *make) {
                make.top.equalTo(@60);
                make.height.equalTo(@60);
            }];
            break;
        }
        case 1: {
            [arr bm_distributeViewsAlongAxis:BMAxisTypeVertical withFixedSpacing:20 leadSpacing:5 tailSpacing:5];
            [arr bm_makeConstraints:^(BMConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
        }
        case 2: {
            [arr bm_distributeViewsAlongAxis:BMAxisTypeHorizontal withFixedItemLength:30 totalLength:[UIScreen mainScreen].bounds.size.width leadSpacing:30 tailSpacing:30];
            [arr bm_makeConstraints:^(BMConstraintMaker *make) {
                make.top.equalTo(@60);
                make.height.equalTo(@60);
            }];
            break;
        }
        case 3: {
            [arr bm_distributeViewsAlongAxis:BMAxisTypeVertical withFixedItemLength:30 totalLength:[UIScreen mainScreen].bounds.size.height-100 leadSpacing:30 tailSpacing:30];
            [arr bm_makeConstraints:^(BMConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@60);
            }];
            break;
        }

        default:
            break;
    }
    
    return self;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


@end
