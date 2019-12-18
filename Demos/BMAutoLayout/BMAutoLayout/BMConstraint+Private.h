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

#import "BMConstraint.h"

@protocol BMConstraintDelegate;

@interface BMConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Usually BMConstraintMaker but could be a parent BMConstraint
 */
@property (nonatomic, weak) id<BMConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with BMEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end

@interface BMConstraint (Abstract)

/**
 *  Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *  UIView, NSValue, NSArray
 */
- (BMConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *  Override to set a custom chaining behaviour
 */
- (BMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end

@protocol BMConstraintDelegate <NSObject>

/**
 *  Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A BMViewConstraint may turn into a BMCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(BMConstraint *)constraint shouldBeReplacedWithConstraint:(BMConstraint *)replacementConstraint;

/**
 * Notifies the delegate when add new constraint
 *
 * @param constraint BMConstraint instance, BMViewConstraint or BMCompositeConstraint
 * @param layoutAttribute layoutAttribute for NSLayoutConstraint
 * @param layoutAnchor first view's anchor
 * @return BMConstraint instance
 */
- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute anchor:(NSLayoutAnchor *)layoutAnchor;

- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

/**
 * Set the content hugging
 *
 * @param priority UILayoutPriority for content hugging
 * @param axis x or y axis
 */
- (void)setContentHuggingPriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis;

/**
 * Set the compression resistance
 *
 * @param priority UILayoutPriority for compression resistance
 * @param axis x or y axis
 */
- (void)setContentCompressionResistancePriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis;

@end
