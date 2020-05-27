//
//  UIView+Addition.h
//  FinanceCar
//
//  Created by mac on 2019/9/17.
//  Copyright © 2019年 NingXiaHaiShengTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Addition.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIView (Addition)


/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Shortcut for frame.origin.x
 */
@property (nonatomic) CGFloat originX;

/**
 * Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat originY;

- (void) addReflection;
- (void) addSimpleReflection;

//add round rect
- (void) clipViewWithRadius: (CGFloat)radius;


/// 添加虚线
/// @param lineColor 虚线颜色
- (void)addShapeLineWithlineColor:(UIColor *)lineColor;


// 自己写的view添加事件
- (void)addTarget:(id)target action:(SEL)action;

- (UIView *)gradientViewWithSize:(CGSize)btnSize
                        colorArray:(NSArray *)clrs
                   percentageArray:(NSArray *)percent
                      gradientType:(GradientType)type;


// 获得所属控制器
- (UIViewController*)viewController;
@end

@interface UIImageView(Additions)

- (void) clipToCircleWithShadow;
- (void) clipViewWithShadowAndRadius: (CGFloat) radius borderColor:(CGColorRef) borderColor;

@end

@interface UIButton (Additions)

- (void) clipToCircleWithShadow;
- (void) clipViewWithShadowAndRadius: (CGFloat) radius;

@end

NS_ASSUME_NONNULL_END
