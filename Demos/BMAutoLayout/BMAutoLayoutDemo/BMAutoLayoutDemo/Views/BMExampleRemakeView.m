//
//  BMExampleRemakeView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleRemakeView.h"
#import <BMAutoLayout/BMAutoLayout.h>

@interface BMExampleRemakeView ()

@property (nonatomic, strong) UIButton *movingButton;
@property (nonatomic, assign) BOOL topLeft;

- (void)toggleButtonPosition;

@end


@implementation BMExampleRemakeView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.movingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.movingButton setTitle:@"Move Me!" forState:UIControlStateNormal];
    self.movingButton.layer.borderColor = UIColor.greenColor.CGColor;
    self.movingButton.layer.borderWidth = 3;
    
    [self.movingButton addTarget:self action:@selector(toggleButtonPosition) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.movingButton];
    
    self.topLeft = YES;
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
// noted safeAreaLayoutGuide is after iOS 11.0
- (void)updateConstraints {
    
    [self.movingButton bm_remakeConstraints:^(BMConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        
        if (self.topLeft) {
            make.left.equalTo(self.safeAreaLayoutGuide.leftAnchor).offset(10);
            make.top.equalTo(self.topAnchor).offset(10);
        }
        else {
            make.bottom.equalTo(self.safeAreaLayoutGuide.bottomAnchor).offset(-10);
            make.right.equalTo(self.rightAnchor).offset(-10);
        }
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)toggleButtonPosition {
    self.topLeft = !self.topLeft;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
