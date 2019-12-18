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

//! Project version number for BMAutoLayout.
FOUNDATION_EXPORT double BMAutoLayoutVersionNumber;

//! Project version string for BMAutoLayout.
FOUNDATION_EXPORT const unsigned char BMAutoLayoutVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BMAutoLayout/PublicHeader.h>

#if __has_include(<BMModel/BMModelLib.h>)
#   import <BMModel/BMUtilities.h>
#   import <BMModel/UIView+BMAdditions.h>
#   import <BMModel/NSArray+BMAdditions.h>
#   import <BMModel/BMConstraint.h>
#   import <BMModel/BMCompositeConstraint.h>
#   import <BMModel/BMConstraintMaker.h>
#else
#   import "BMUtilities.h"
#   import "UIView+BMAdditions.h"
#   import "NSArray+BMAdditions.h"
#   import "BMConstraint.h"
#   import "BMCompositeConstraint.h"
#   import "BMConstraintMaker.h"
#endif


