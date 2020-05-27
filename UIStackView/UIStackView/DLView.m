//
//  DLView.m
//  UIStackView
//
//  Created by 刘威振 on 2020/5/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "DLView.h"

@interface DLView()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@end

@implementation DLView

// Axis: 指定horizontal或vertical
 // Alignment: 子控件的布局位置 fill leading trailing center
 // Distribution: 控制子控件大小
 // Spacing: 子控件之间的间距
// self.stackView.alignment = UILayoutConstraintAxisHorizontal; // 水平布局子控件
// self.stackView.backgroundColor = [UIColor redColor];
// [self.view addSubview:self.stackView];

- (void)refreshWithOne:(NSString *)one two:(NSString *)two three:(NSString *)three {
    self.label1.text = one;
    self.label2.text = two;
    self.label3.text = three;
    
    [self.label1 sizeToFit];
    [self.label2 sizeToFit];
    [self.label3 sizeToFit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 假设是水平方向布局
        self.stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.stackView.alignment = UIStackViewAlignmentCenter; // UILayoutConstraintAxisHorizontal;
        // ----------- alignment ------------------
        // UIStackViewAlignmentLeading：顶部对齐
        // UIStackViewAlignmentFill: 平铺 Align the leading and trailing edges of vertically stacked items or the top and bottom edges of horizontally stacked items tightly to the container.
        // UIStackViewAlignmentLeading: Align the leading edges of vertically stacked items or the top edges of horizontally stacked items tightly to the relevant edge of the container
        // UIStackViewAlignmentTop = UIStackViewAlignmentLeading,
        // UIStackViewAlignmentFirstBaseline:  Valid for horizontal axis only
        // UIStackViewAlignmentCenter: 居中对齐 Center the items in a vertical stack horizontally or the items in a horizontal stack vertically
        // UIStackViewAlignmentTrailing: Align the trailing edges of vertically stacked items or the bottom edges of horizontally stacked items tightly to the relevant edge of the container
        // UIStackViewAlignmentBottom = UIStackViewAlignmentTrailing,
        // UIStackViewAlignmentLastBaseline: Valid for horizontal axis only
        
        // self.stackView.spacing = 5; // item之间的间距
        // self.stackView.distribution = UIStackViewDistributionEqualSpacing; // 等间距， 优先级大于spacing， 等间距计算得到的间距值会替换item之间的间距值spacing
        
        // self.stackView.alignment = UIStackViewAlignmentTrailing; // 对于水平布局，底部对齐
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        [self addSubview:self.stackView];
        
        // --------- distribution -----------
        /**
         ypedef NS_ENUM(NSInteger, UIStackViewDistribution) {
             UIStackViewDistributionFill = 0, // 平铺，填满，里面的子视图通过自动布局实现
             UIStackViewDistributionFillEqually, // 在水平布局中，子视图宽度一致，在垂直布局中，子视图高度一致
             UIStackViewDistributionFillProportionally, // 按照原比例缩放
             UIStackViewDistributionEqualSpacing, // 均匀分布
             UIStackViewDistributionEqualCentering,
         } NS_ENUM_AVAILABLE_IOS(9_0);
         */
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self addChildViewsIfNeeded];
}

- (void)addChildViewsIfNeeded {
    if (!self.label1) {
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        self.label1.backgroundColor = [UIColor redColor];
        [self.stackView addArrangedSubview:self.label1];
    }
    
    if (!self.label2) {
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label1.frame), 0, 0, 30)];
        self.label2.numberOfLines = 0;
        self.label2.backgroundColor = [UIColor greenColor];
        self.label2.textAlignment = NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:self.label2];
    }
    
    if (!self.label3) {
        self.label3 = [[UILabel alloc] init];
        self.label3.backgroundColor = [UIColor blueColor];
        [self.stackView addArrangedSubview:self.label3];
    }
    
    [self.stackView setCustomSpacing:5.0 afterView:self.label2];
    
//    CGRect frame = self.stackView.frame;
//    frame.size.width = self.label1.frame.size.width + self.label2.frame.size.width + self.label3.frame.size.width + 5;
//    self.stackView.frame = frame;
}

@end
