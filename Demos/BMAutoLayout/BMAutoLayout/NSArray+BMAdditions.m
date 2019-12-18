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

#import "NSArray+BMAdditions.h"
#import "UIView+BMAdditions.h"

@implementation NSArray (BMAdditions)

- (NSArray *)bm_makeConstraints:(void (NS_NOESCAPE^)(BMConstraintMaker *))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        NSAssert([view isKindOfClass:[UIView class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view bm_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)bm_updateConstraints:(void (NS_NOESCAPE ^)(BMConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        NSAssert([view isKindOfClass:[UIView class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view bm_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)bm_remakeConstraints:(void (NS_NOESCAPE ^)(BMConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (UIView *view in self) {
        NSAssert([view isKindOfClass:[UIView class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view bm_remakeConstraints:block]];
    }
    return constraints;
}

- (void)bm_distributeViewsAlongAxis:(BMAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    UIView *tempSuperView = [self bm_commonSuperviewOfViews];
    if (axisType == BMAxisTypeHorizontal) {
        UIView *pre;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                if (pre) {
                    make.width.equalTo(pre.widthAnchor);
                    make.left.equalTo(pre.rightAnchor).offset(@(fixedSpacing));
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView.rightAnchor).offset(@(-tailSpacing));
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView.leftAnchor).offset(@(leadSpacing));
                }
            }];
            pre = v;
        }
    }
    else {
        UIView *pre;
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                if (pre) {
                    make.height.equalTo(pre.heightAnchor);
                    make.top.equalTo(pre.bottomAnchor).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            pre = v;
        }
    }
}

- (void)bm_distributeViewsAlongAxis:(BMAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength totalLength:(CGFloat)totalLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    UIView *tempSuperView = [self bm_commonSuperviewOfViews];

    tempSuperView.backgroundColor = [UIColor redColor];
    if (axisType == BMAxisTypeHorizontal) {
        UIView *prev;
        CGFloat spacing = (totalLength - leadSpacing - tailSpacing - self.count * fixedItemLength) / (self.count - 1);
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    make.left.equalTo(prev.rightAnchor).offset(spacing);
                }
                else {
                    make.left.equalTo(tempSuperView.leftAnchor).offset(leadSpacing);
                }
            }];
            prev = v;
        }
        /*
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                         CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                         make.right.equalTo(tempSuperView.rightAnchor).multipliedBy(i/((CGFloat)self.count-1)).offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
        */
    }
    else {
        UIView *prev;
        CGFloat spacing = (totalLength - leadSpacing - tailSpacing - self.count * fixedItemLength) / (self.count - 1);
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    make.top.equalTo(prev.bottomAnchor).offset(spacing);
                }
                else {
                    make.top.equalTo(tempSuperView.topAnchor).offset(leadSpacing);
                }
            }];
            prev = v;
        }
        /**
        for (int i = 0; i < self.count; i++) {
            UIView *v = self[i];
            [v bm_makeConstraints:^(BMConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
        */
    }
}

- (UIView *)bm_commonSuperviewOfViews {
    UIView *commonSuperview = nil;
    UIView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)object;
            if (previousView) {
                commonSuperview = [view bm_closestCommonSuperview:commonSuperview];
            }
            else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}


@end
