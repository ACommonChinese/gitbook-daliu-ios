//
//  BMExampleAspectFitView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleAspectFitView.h"
#import <BMAutoLayout/BMAutoLayout.h>

@interface BMExampleAspectFitView ()

@property UIView *topView;
@property UIView *topInnerView;
@property UIView *bottomView;
@property UIView *bottomInnerView;

@end

@implementation BMExampleAspectFitView

// Designated initializer
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        // Create views
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topInnerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomInnerView = [[UIView alloc] initWithFrame:CGRectZero];

        // Set background colors
        UIColor *blueColor = [UIColor colorWithRed:0.663 green:0.796 blue:0.996 alpha:1];
        [self.topView setBackgroundColor:blueColor];

        UIColor *lightGreenColor = [UIColor colorWithRed:0.784 green:0.992 blue:0.851 alpha:1];
        [self.topInnerView setBackgroundColor:lightGreenColor];

        UIColor *pinkColor = [UIColor colorWithRed:0.992 green:0.804 blue:0.941 alpha:1];
        [self.bottomView setBackgroundColor:pinkColor];

        UIColor *darkGreenColor = [UIColor colorWithRed:0.443 green:0.780 blue:0.337 alpha:1];
        [self.bottomInnerView setBackgroundColor:darkGreenColor];

        // Layout top and bottom views to each take up half of the window
        [self addSubview:self.topView];

        [self.topView bm_makeConstraints:^(BMConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];

        [self addSubview:self.bottomView];
        [self.bottomView bm_makeConstraints:^(BMConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.topView.bottomAnchor);
            make.height.equalTo(self.topView);
        }];

        // Inner views are configured for aspect fit with ratio of 3:1
        [self.topView addSubview:self.topInnerView];

        [self.topInnerView bm_makeConstraints:^(BMConstraintMaker *make) {
            make.width.equalTo(self.topInnerView.heightAnchor).multipliedBy(3);
            make.width.height.lessThanOrEqualTo(self.topView);
            make.width.height.equalTo(self.topView).priorityLow();
            make.center.equalTo(self.topView);
        }];

        [self.bottomView addSubview:self.bottomInnerView];
        [self.bottomInnerView bm_makeConstraints:^(BMConstraintMaker *make) {
            make.height.equalTo(self.bottomInnerView.widthAnchor).multipliedBy(3);
            make.width.height.lessThanOrEqualTo(self.bottomView);
            make.width.height.equalTo(self.bottomView).priorityLow();
            make.center.equalTo(self.bottomView);
        }];
    }
    
    return self;
}

@end
