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

/**
 *  Provides factory methods for creating MASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface BMConstraintMaker : NSObject

/**
 *  The following properties return a new BMViewConstraint
 *  with the first item set to the makers associated view and the appropriate BMViewAnchor
 */
@property(nonatomic,readonly,strong) BMConstraint *leading;
@property(nonatomic,readonly,strong) BMConstraint *trailing;
@property(nonatomic,readonly,strong) BMConstraint *left;
@property(nonatomic,readonly,strong) BMConstraint *right;
@property(nonatomic,readonly,strong) BMConstraint *top;
@property(nonatomic,readonly,strong) BMConstraint *bottom;
@property(nonatomic,readonly,strong) BMConstraint *width;
@property(nonatomic,readonly,strong) BMConstraint *height;
@property(nonatomic,readonly,strong) BMConstraint *centerX;
@property(nonatomic,readonly,strong) BMConstraint *centerY;
@property(nonatomic,readonly,strong) BMConstraint *firstBaseline;
@property(nonatomic,readonly,strong) BMConstraint *lastBaseline;

/**
 * Sets the target view's alix-x content hugging priority
 */
- (BMConstraintMaker * (^)(UILayoutPriority priority))xContentHuggingPriority;

/**
 * Sets the target view's alix-y content hugging priority
 */
- (BMConstraintMaker * (^)(UILayoutPriority priority))yContentHuggingPriority;

/**
 * Sets the target view's alix-x content compression resistance priortiy
 */
- (BMConstraintMaker * (^)(UILayoutPriority priority))xContentCompressionResistancePriority;

/**
 * Sets the target view's alix-y content compression resistance priority
 */
- (BMConstraintMaker * (^)(UILayoutPriority priority))yContentCompressionResistancePriority;

/**
 *  Creates a BMCompositeConstraint with [left、top、right、bottom]
 *  which generates the appropriate BMViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) BMConstraint *edges;

/**
 *  Creates a BMCompositeConstraint with [width、height]
 *  which generates the appropriate BMViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) BMConstraint *size;

/**
 *  Creates a BMCompositeConstraint with [centerX、centerY]
 *  which generates the appropriate MASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) BMConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *  initialises the maker with a default view
 *
 *  @param view any MASConstraint are created with this view as the first item
 *
 *  @return a new MASConstraintMaker
 */
- (id)initWithView:(UIView *)view;

/**
 *  Calls install method on any BMConstraints which have been created by this maker
 *
 *  @return an array of all the installed BMConstraints
 */
- (NSArray *)install;

@end
