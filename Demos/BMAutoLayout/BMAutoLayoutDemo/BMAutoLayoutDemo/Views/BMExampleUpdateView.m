//
//  BMExampleUpdateView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleUpdateView.h"
#import <BMAutoLayout/BMAutoLayout.h>

@interface BMExampleUpdateView ()

@property (nonatomic, strong) UIButton *growingButton;
@property (nonatomic, assign) CGSize buttonSize;

@end

@implementation BMExampleUpdateView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.growingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.growingButton setTitle:@"Grow Me!" forState:UIControlStateNormal];
    self.growingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.growingButton.layer.borderWidth = 3;
    
    [self.growingButton addTarget:self action:@selector(didTapGrowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.growingButton];
    
    self.buttonSize = CGSizeMake(100, 100);
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    [self.growingButton bm_updateConstraints:^(BMConstraintMaker *make) {
        make.center.key(@"center").equalTo(self);
        
        make.width.key(@"width").equalTo(@(self.buttonSize.width));
        make.height.key(@"height").equalTo(@(self.buttonSize.height));
//        make.width.lessThanOrEqualTo(self).priorityRequired();
//        make.height.lessThanOrEqualTo(self).priorityRequired();
        
//        make.width.equalTo(@(self.buttonSize.width)).priorityRequired();
//        make.height.equalTo(@(self.buttonSize.height)).priorityRequired();
//        make.width.lessThanOrEqualTo(self).priorityRequired();
//        make.height.lessThanOrEqualTo(self).priorityRequired();
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)didTapGrowButton:(UIButton *)button {
    self.buttonSize = CGSizeMake(self.buttonSize.width * 1.3, self.buttonSize.height * 1.3);
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
