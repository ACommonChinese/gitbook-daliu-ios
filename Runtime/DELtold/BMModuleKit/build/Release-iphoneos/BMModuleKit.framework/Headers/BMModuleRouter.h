///***************************************************************************************
// *
// *  Project:        BMModuleKit
// *
// *  Copyright ©     2014-2019 Banma Technologies Co.,Ltd
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
// *  Header Name: BMModuleRouter.h
// *
// *  General Description: Copyright and file header.
// *
// *  Created by Chris on 2019/2/19.
// *
// ****************************************************************************************/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class BMModuleRouter
 */
@interface BMModuleRouter : NSObject

/**
 * Creates and returns a 'BMModuleRouter' object
 */
+ (BMModuleRouter *)sharedRouter;

/**
 * @method addModule:
 */
- (void)addModule:(Class)targetClass, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @method removeModule:
 */
- (void)removeModule:(Class)targetClass;

/**
 * @method route:
 */
- (void *)route:(NSString *)url, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * @method target:
 */
- (id)target:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
