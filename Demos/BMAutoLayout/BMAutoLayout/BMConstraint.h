///***************************************************************************************
// *
// *  Project:        BMAutoLayout
// *
// *  Copyright ©     2014-2018 Banma Technologies Co.,Ltd
// *                  All rights reserved.
// *
// *  This software is supplied only under the terms of a license agreement,
// *  nondisclosure agreement or other written agreement with Banma Technologies
// *  Co.,Ltd. Use, redistribution or other disclosure of any parts of this
// *  software is prohibited except in accordance with the terms of such written
// *  agreement with Banma Technologies Co.,Ltd. This software is confidential
// *  and proprietary information of Banma Technologies Co.,Ltd.
// *
// ***************************************************************************************
// *
// *  Header Name: BMModel.h
// *
// *  General Description: Copyright and file header.
// *
// *  Created by DaLiu on 13/05/2019.
// *
// *  JiraID : ZXQAPP-110
// *
// ****************************************************************************************/

#import <UIKit/UIKit.h>
#import "BMUtilities.h"

/**
 *  Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (BMViewConstraint)
 *  or a group of NSLayoutConstraints (BMComposisteConstraint)
 */
@interface BMConstraint : NSObject

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (BMConstraint * (^)(UIEdgeInsets insets))insets;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(UIEdgeInsets)insets;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects MASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (BMConstraint * (^)(CGFloat inset))inset;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (BMConstraint * (^)(CGSize offset))sizeOffset;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (BMConstraint * (^)(CGPoint offset))centerOffset;

/**
 *  Modifies the NSLayoutConstraint constant,
 *  only affects BMConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *  Modifies the NSLayoutConstraint constant
 */
- (BMConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (BMConstraint * (^)(NSValue *value))valueOffset;

/**
 *  Sets the NSLayoutConstraint multiplier property
 */
- (BMConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *  Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (BMConstraint * (^)(CGFloat divider))dividedBy;

/**
 *  Sets the NSLayoutConstraint priority to a float
 */
- (BMConstraint * (^)(UILayoutPriority priority))priority;

/**
 *  Sets the NSLayoutConstraint priority to UILayoutPriorityLow
 */
- (BMConstraint * (^)(void))priorityLow;

/**
 *  Sets the NSLayoutConstraint priority to 500
 */
- (BMConstraint * (^)(void))priorityMedium;

/**
 *  Sets the NSLayoutConstraint priority to UILayoutPriorityHigh
 */
- (BMConstraint * (^)(void))priorityHigh;

/**
 *  Sets the NSLayoutConstraint priority to UILayoutPriorityRequired
 */
- (BMConstraint * (^)(void))priorityRequired;

/**
 *  Sets the NSLayoutConstraint priority to UILayoutPriorityFittingSizeLevel
 */
- (BMConstraint * (^)(void))priorityFittingSizeLevel;

/**
 *  Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *  UIView, NSValue, NSArray
 */
- (BMConstraint * (^)(id attr))equalTo;

/**
 *  Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *  UIView, NSValue, NSArray
 */
- (BMConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *  Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *  UIView, NSValue, NSArray
 */
- (BMConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 * Sets the target view's alix-x content hugging priority
 */
- (BMConstraint * (^)(UILayoutPriority priority))xContentHuggingPriority;

/**
 * Sets the target view's alix-y content hugging priority
 */
- (BMConstraint * (^)(UILayoutPriority priority))yContentHuggingPriority;

/**
 * Sets the target view's alix-x content compression resistance priortiy
 */
- (BMConstraint * (^)(UILayoutPriority priority))xContentCompressionResistancePriority;

/**
 * Sets the target view's alix-y content compression resistance priority
 */
- (BMConstraint * (^)(UILayoutPriority priority))yContentCompressionResistancePriority;

/**
 *  Creates a new BMCompositeConstraint with the called attribute and reciever
 */
- (BMConstraint *)leading;
- (BMConstraint *)trailing;
- (BMConstraint *)left;
- (BMConstraint *)right;
- (BMConstraint *)top;
- (BMConstraint *)bottom;
- (BMConstraint *)width;
- (BMConstraint *)height;
- (BMConstraint *)centerX;
- (BMConstraint *)centerY;
- (BMConstraint *)firstBaseline;
- (BMConstraint *)lastBaseline;

/**
 *  Sets the constraint debug name
 */
- (BMConstraint * (^)(id key))key;

/**
 *  Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *  Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end

/**
 *  Convenience auto-boxing macros for BMConstraint methods.
 */
#define bm_equalTo(...)                 equalTo(BMBoxValue((__VA_ARGS__)))
#define bm_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(BMBoxValue((__VA_ARGS__)))
#define bm_lessThanOrEqualTo(...)       lessThanOrEqualTo(BMBoxValue((__VA_ARGS__)))

#define bm_offset(...)                  valueOffset(BMBoxValue((__VA_ARGS__)))

#define equalTo(...)                     bm_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        bm_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           bm_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      bm_offset(__VA_ARGS__)


@interface BMConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (BMConstraint * (^)(id attr))bm_equalTo;
- (BMConstraint * (^)(id attr))bm_greaterThanOrEqualTo;
- (BMConstraint * (^)(id attr))bm_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (BMConstraint * (^)(id offset))bm_offset;

@end


