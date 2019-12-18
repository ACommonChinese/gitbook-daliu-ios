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

#import "UIView+BMAdditions.h"
#import <objc/runtime.h>

@implementation UIView (BMAdditions)

static char kInstalledConstraintsKey;

- (NSMutableSet *)bm_installedConstraints {
    NSMutableSet *constraints = objc_getAssociatedObject(self, &kInstalledConstraintsKey);
    if (!constraints) {
        constraints = [NSMutableSet set];
        objc_setAssociatedObject(self, &kInstalledConstraintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return constraints;
}

- (instancetype)bm_closestCommonSuperview:(UIView *)view {
    UIView *closestCommonSuperview = nil;
    
    UIView *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        UIView *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

- (NSArray *)bm_makeConstraints:(void(NS_NOESCAPE^)(BMConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    BMConstraintMaker *constraintMaker = [[BMConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)bm_updateConstraints:(void (NS_NOESCAPE^)(BMConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    BMConstraintMaker *constraintMaker = [[BMConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)bm_remakeConstraints:(void(NS_NOESCAPE ^)(BMConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    BMConstraintMaker *constraintMaker = [[BMConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - associated properties

- (id)bm_key {
    return objc_getAssociatedObject(self, @selector(bm_key));
}

- (void)setBm_key:(id)key {
    objc_setAssociatedObject(self, @selector(bm_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
