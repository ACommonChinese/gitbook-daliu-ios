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

@interface BMViewConstraint : BMConstraint

/// First view anchor
@property (nonatomic, strong, readonly) NSLayoutAnchor *firstAnchor;

/// view for first anchor
@property (nonatomic, weak) UIView *firstAnchorView;

/// First view layout attribute
@property (nonatomic, assign, readonly) NSLayoutAttribute attribute;

/// Second view anchor
@property (nonatomic, strong, readonly) NSLayoutAnchor *secondAnchor;

/**
 * initialises the BMViewConstraint with the first part of the equation
 *
 * @param attribute first view layout attribute
 *
 * @param anchor first view anchor
 *
 * @return a new view constraint
 */
- (id)initWithAttribute:(NSLayoutAttribute)attribute anchor:(NSLayoutAnchor *)anchor;

/**
 * Get anchor that match layoutAttribute
 *
 * @param view A view to retrieve anchor
 *
 * @param layoutAttribute NSLayoutAttribute
 *
 * @return matched anchor
 */
+ (NSLayoutAnchor *)matchedAnchorForView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute;

@end
