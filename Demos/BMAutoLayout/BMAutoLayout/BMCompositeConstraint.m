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

#import "BMCompositeConstraint.h"
#import "BMConstraint+Private.h"

@interface BMCompositeConstraint () <BMConstraintDelegate>

@property (nonatomic, strong) id bm_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

@implementation BMCompositeConstraint

- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;
    
    _childConstraints = [children mutableCopy];
    for (BMConstraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }
    
    return self;
}

#pragma mark - MASConstraintDelegate

- (void)constraint:(BMConstraint *)constraint shouldBeReplacedWithConstraint:(BMConstraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute anchor:(NSLayoutAnchor *)layoutAnchor {
    id<BMConstraintDelegate> strongDelegate = self.delegate;
    BMConstraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute anchor:layoutAnchor];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

#pragma mark - NSLayoutConstraint multiplier proxies

- (BMConstraint *(^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (BMConstraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}

- (BMConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (BMConstraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}

- (BMConstraint * (^)(UILayoutPriority))priority {
    return ^id(UILayoutPriority priority) {
        for (BMConstraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}

- (BMConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (BMConstraint *constraint in self.childConstraints.copy) {
            constraint.equalToWithRelation(attr, relation);
        }
        return self;
    };
}

- (BMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}

- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<BMConstraintDelegate> strongDelegate = self.delegate;
    BMConstraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

- (BMConstraint * (^)(id))key {
    return ^id(id key) {
        self.bm_key = key;
        int i = 0;
        for (BMConstraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}

- (void)setContentHuggingPriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis {
    [self.delegate setContentHuggingPriority:priority forAxis:axis];
}

- (void)setContentCompressionResistancePriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis {
    [self.delegate setContentCompressionResistancePriority:priority forAxis:axis];
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(UIEdgeInsets)insets {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}

- (void)setInset:(CGFloat)inset {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.inset = inset;
    }
}

- (void)setOffset:(CGFloat)offset {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}

#pragma mark - BMConstraint

- (void)install {
    for (BMConstraint *constraint in self.childConstraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
}

- (void)uninstall {
    for (BMConstraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}

@end
