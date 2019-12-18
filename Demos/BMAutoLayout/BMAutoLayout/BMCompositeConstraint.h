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
 *  A group of MASConstraint objects
 */
@interface BMCompositeConstraint : BMConstraint

/**
 *  Creates a composite with a predefined array of children
 *
 *  @param children child MASConstraints
 *
 *  @return a composite constraint
 */
- (id)initWithChildren:(NSArray<BMConstraint *> *)children;

@end
