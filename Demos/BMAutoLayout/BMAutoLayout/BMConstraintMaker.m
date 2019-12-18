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

#import "BMConstraintMaker.h"
#import "UIView+BMAdditions.h"
#import "BMConstraint+Private.h"
#import "BMViewConstraint.h"
#import "BMCompositeConstraint.h"
#import <objc/runtime.h>

@interface BMConstraintMaker () <BMConstraintDelegate>

@property (nonatomic, weak) UIView *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@property (nonatomic, assign) UILayoutPriority xLayoutContentHuggingPriority;
@property (nonatomic, assign) UILayoutPriority yLayoutContentHuggingPriority;
@property (nonatomic, assign) UILayoutPriority xLayoutContentCompressionResistancePriority;
@property (nonatomic, assign) UILayoutPriority yLayoutContentCompressionResistancePriority;

@end

@implementation BMConstraintMaker

- (id)initWithView:(UIView *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [self.view.bm_installedConstraints allObjects];
        for (BMConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (BMConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    
    if (_xLayoutContentHuggingPriority) {
        [self.view setContentHuggingPriority:_xLayoutContentHuggingPriority forAxis:UILayoutConstraintAxisHorizontal];
    }
    if (_yLayoutContentHuggingPriority) {
        [self.view setContentHuggingPriority:_yLayoutContentHuggingPriority forAxis:UILayoutConstraintAxisVertical];
    }
    if (_xLayoutContentCompressionResistancePriority) {
        [self.view setContentCompressionResistancePriority:_xLayoutContentCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
    }
    if (_yLayoutContentCompressionResistancePriority) {
        [self.view setContentCompressionResistancePriority:_yLayoutContentCompressionResistancePriority forAxis:UILayoutConstraintAxisVertical];
    }
    
    return constraints;
}

#pragma mark - BMConstraintDelegate

- (void)constraint:(BMConstraint *)constraint shouldBeReplacedWithConstraint:(BMConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute anchor:(NSLayoutAnchor *)layoutAnchor {
    BMViewConstraint *newConstraint = [[BMViewConstraint alloc] initWithAttribute:layoutAttribute anchor:layoutAnchor];
    newConstraint.firstAnchorView = self.view;
    
    if ([constraint isKindOfClass:[BMViewConstraint class]]) {
        NSArray *children = @[constraint, newConstraint];
        BMCompositeConstraint *compositeConstraint = [[BMCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (void)constraintDidInstall:(BMConstraint *)constraint {
    [self.view.bm_installedConstraints addObject:constraint];
}

- (void)constraintDidUnInstall:(BMConstraint *)constraint {
    [self.view.bm_installedConstraints removeObject:constraint];
}

- (void)setContentHuggingPriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis {
    if (axis == UILayoutConstraintAxisHorizontal) {
        _xLayoutContentHuggingPriority = priority;
    }
    else {
        _yLayoutContentHuggingPriority = priority;
    }
}

- (void)setContentCompressionResistancePriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis {
    if (axis == UILayoutConstraintAxisHorizontal) {
        _xLayoutContentCompressionResistancePriority = priority;
    }
    else {
        _yLayoutContentCompressionResistancePriority = priority;
    }
}

#pragma mark - standard Attributes

- (BMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute anchor:(NSLayoutAnchor *)layoutAnchor {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute anchor:layoutAnchor];
}

- (BMConstraint *)constraint:(BMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:constraint addConstraintWithLayoutAttribute:layoutAttribute anchor:[BMViewConstraint matchedAnchorForView:self.view attribute:layoutAttribute]];
}

- (BMConstraint *)addConstraints:(NSArray<BMConstraint *> *)constraints {
    BMCompositeConstraint *newConstraint = [[BMCompositeConstraint alloc] initWithChildren:constraints];
    newConstraint.delegate = self;
    [self.constraints addObject:newConstraint];
    return newConstraint;
}

- (BMConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading anchor:self.view.leadingAnchor];
}

- (BMConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing anchor:self.view.trailingAnchor];
}

- (BMConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft anchor:self.view.leftAnchor];
}

- (BMConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight anchor:self.view.rightAnchor];
}

- (BMConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop anchor:self.view.topAnchor];
}

- (BMConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom anchor:self.view.bottomAnchor];
}

- (BMConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth anchor:self.view.widthAnchor];
}

- (BMConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight anchor:self.view.heightAnchor];
}

- (BMConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX anchor:self.view.centerXAnchor];
}

- (BMConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY anchor:self.view.centerYAnchor];
}

- (BMConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline anchor:self.view.firstBaselineAnchor];
}

- (BMConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline anchor:self.view.lastBaselineAnchor];
}

- (BMConstraintMaker *(^)(UILayoutPriority))xContentHuggingPriority {
    return ^BMConstraintMaker *(UILayoutPriority priority) {
        [self.view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (BMConstraintMaker *(^)(UILayoutPriority))yContentHuggingPriority {
    return ^BMConstraintMaker *(UILayoutPriority priority) {
        [self.view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

- (BMConstraintMaker *(^)(UILayoutPriority))xContentCompressionResistancePriority {
    return ^BMConstraintMaker *(UILayoutPriority priority) {
        [self.view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (BMConstraintMaker *(^)(UILayoutPriority))yContentCompressionResistancePriority {
    return ^BMConstraintMaker *(UILayoutPriority priority) {
        [self.view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

#pragma mark - composite Attributes

- (BMConstraint *)edges {
    return [self addConstraints:@[self.left, self.top, self.right, self.bottom]];
}

- (BMConstraint *)size {
    return [self addConstraints:@[self.width, self.height]];
}

- (BMConstraint *)center {
    return [self addConstraints:@[self.centerX, self.centerY]];
}

@end
