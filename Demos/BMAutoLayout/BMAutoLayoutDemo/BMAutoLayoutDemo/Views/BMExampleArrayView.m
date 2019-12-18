//
//  BMExampleArrayView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleArrayView.h"
#import <BMAutoLayout/BMAutoLayout.h>

static CGFloat const kArrayExampleIncrement = 10.0;

@interface BMExampleArrayView ()

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, strong) NSArray *buttonViews;

@end

@implementation BMExampleArrayView


- (id)init {
    self = [super init];
    if (!self) return nil;
    
    UIButton *raiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [raiseButton setTitle:@"Raise" forState:UIControlStateNormal];
    [raiseButton addTarget:self action:@selector(raiseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:raiseButton];
    
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [centerButton setTitle:@"Center" forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerButton];
    
    UIButton *lowerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [lowerButton setTitle:@"Lower" forState:UIControlStateNormal];
    [lowerButton addTarget:self action:@selector(lowerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lowerButton];
    
    raiseButton.backgroundColor = centerButton.backgroundColor = lowerButton.backgroundColor = [UIColor yellowColor];
    
    UIView *markView = UIView.new;
    markView.backgroundColor = [UIColor redColor];
    [self addSubview:markView];
    [markView bm_makeConstraints:^(BMConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(1);
        make.center.equalTo(self);
    }];
    
    [lowerButton bm_makeConstraints:^(BMConstraintMaker *make) {
        make.left.equalTo(self).offset(10.0);
    }];
    
    [centerButton bm_makeConstraints:^(BMConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
    
    [raiseButton bm_makeConstraints:^(BMConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
    }];
    
    self.buttonViews = @[ raiseButton, lowerButton, centerButton ];
    
    return self;
}

- (void)centerAction {
    self.offset = 0.0;
}

- (void)raiseAction {
    self.offset -= kArrayExampleIncrement;
}

- (void)lowerAction {
    self.offset += kArrayExampleIncrement;
}

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.buttonViews bm_updateConstraints:^(BMConstraintMaker *make) {
        make.lastBaseline.equalTo(self.centerYAnchor).offset(self.offset);
        // make.centerY.equalTo(self.bm_centerY).with.offset(self.offset);
    }];

    //according to apple super should be called at end of method
    [super updateConstraints];
}

@end
