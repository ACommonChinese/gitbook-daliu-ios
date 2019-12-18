//
//  BMExampleLabelView.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleLabelView.h"
#import <BMAutoLayout/BMAutoLayout.h>

static UIEdgeInsets const kPadding = {10, 10, 10, 10};

@interface BMExampleLabelView ()

@property (nonatomic, strong) UILabel *shortLabel;
@property (nonatomic, strong) UILabel *longLabel;

@end

@implementation BMExampleLabelView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    // text courtesy of http://baconipsum.com/
    
    self.shortLabel = UILabel.new;
    self.shortLabel.numberOfLines = 1;
    self.shortLabel.textColor = [UIColor purpleColor];
    self.shortLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.shortLabel.text = @"Bacon";
    [self addSubview:self.shortLabel];
    
    CGFloat maxLongLabelWidth = [UIScreen mainScreen].bounds.size.width - self.shortLabel.intrinsicContentSize.width - 2*kPadding.left;
    
    self.longLabel = UILabel.new;
    self.longLabel.numberOfLines = 8;
    self.longLabel.textColor = [UIColor darkGrayColor];
    self.longLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.longLabel.preferredMaxLayoutWidth = maxLongLabelWidth; /// The preferred maximum width (in points) for a multiline label.
    self.longLabel.text = @"Bacon ipsum dolor sit amet spare ribs fatback kielbasa salami, tri-tip jowl pastrami flank short loin rump sirloin. Tenderloin frankfurter chicken biltong rump chuck filet mignon pork t-bone flank ham hock.";
    [self addSubview:self.longLabel];
    
    [self.longLabel bm_makeConstraints:^(BMConstraintMaker *make) {
        make.left.equalTo(self.leftAnchor).insets(kPadding);
        make.top.equalTo(self.topAnchor).insets(kPadding);
    }];
    
    [self.shortLabel bm_makeConstraints:^(BMConstraintMaker *make) {
        make.top.equalTo(self.longLabel.lastBaselineAnchor);
        make.right.equalTo(self.rightAnchor).insets(kPadding);
    }];
    
    return self;
}

@end
