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
#import "BMConstraintMaker.h"

@interface UIView (BMAdditions)

/**
 * a key to associate with this view
 */
@property (nonatomic, strong) id bm_key;

/**
 * the BMViewConstraint instances for NSLayoutConstraint
 */
@property (nonatomic, readonly) NSMutableSet *bm_installedConstraints;

/**
 *  Finds the closest common superview between this view and another view
 *
 *  @param view other view
 *
 *  @return returns nil if common superview could not be found
 */
- (instancetype)bm_closestCommonSuperview:(UIView *)view;

/**
 *  Creates a BMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MASConstraints
 */
- (NSArray *)bm_makeConstraints:(void(NS_NOESCAPE ^)(BMConstraintMaker *make))block;

/**
 *  Creates a BMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated BMConstraints
 */
- (NSArray *)bm_updateConstraints:(void(NS_NOESCAPE ^)(BMConstraintMaker *make))block;

/**
 *  Creates a BMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated BMConstraints
 */
- (NSArray *)bm_remakeConstraints:(void(NS_NOESCAPE ^)(BMConstraintMaker *make))block;

@end
