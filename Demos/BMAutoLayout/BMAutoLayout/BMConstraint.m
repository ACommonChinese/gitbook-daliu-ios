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
#import "BMConstraint+Private.h"

#define BMMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
        reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation BMConstraint

- (id)init {
    NSAssert(![self isMemberOfClass:[BMConstraint class]], @"BMConstraint is an abstract class, you should not instantiate it directly.");
    return [super init];
}

- (BMConstraint *(^)(UIEdgeInsets))insets {
    return ^id(UIEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (void)setInsets:(UIEdgeInsets __unused)insets { BMMethodNotImplemented(); }

- (BMConstraint *(^)(CGFloat))inset {
    return ^id(CGFloat inset){
        self.inset = inset;
        return self;
    };
}

- (void)setInset:(CGFloat __unused)inset { BMMethodNotImplemented(); }

- (BMConstraint *(^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (void)setSizeOffset:(CGSize __unused)sizeOffset { BMMethodNotImplemented(); }

- (BMConstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (void)setCenterOffset:(CGPoint __unused)centerOffset { BMMethodNotImplemented(); }

- (BMConstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (BMConstraint *(^)(id))bm_offset {
    // Will never be called due to macro
    return nil;
}

- (void)setOffset:(CGFloat __unused)offset { BMMethodNotImplemented(); }

- (BMConstraint *(^)(NSValue *))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}

- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

- (BMConstraint *(^)(CGFloat))multipliedBy { BMMethodNotImplemented(); }

- (BMConstraint *(^)(CGFloat))dividedBy { BMMethodNotImplemented(); }

- (BMConstraint * (^)(UILayoutPriority priority))priority { BMMethodNotImplemented(); }

- (BMConstraint * (^)(void))priorityLow {
    return ^id{
        self.priority(UILayoutPriorityDefaultLow);
        return self;
    };
}

- (BMConstraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(500);
        return self;
    };
}

- (BMConstraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(UILayoutPriorityDefaultHigh);
        return self;
    };
}

- (BMConstraint * (^)(void))priorityRequired {
    return ^id{
        self.priority(UILayoutPriorityRequired);
        return self;
    };
}

- (BMConstraint * (^)(void))priorityFittingSizeLevel {
    return ^id{
        self.priority(UILayoutPriorityFittingSizeLevel);
        return self;
    };
}

- (BMConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (BMConstraint *(^)(id))bm_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (BMConstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (BMConstraint *(^)(id))bm_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (BMConstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (BMConstraint *(^)(id))bm_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (BMConstraint *(^)(UILayoutPriority))xContentHuggingPriority {
    return ^BMConstraint *(UILayoutPriority priority) {
        [self.delegate setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (BMConstraint *(^)(UILayoutPriority))yContentHuggingPriority {
    return ^BMConstraint *(UILayoutPriority priority) {
        [self.delegate setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

- (BMConstraint *(^)(UILayoutPriority))xContentCompressionResistancePriority {
    return ^BMConstraint *(UILayoutPriority priority) {
        [self.delegate setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
        return self;
    };
}

- (BMConstraint *(^)(UILayoutPriority))yContentCompressionResistancePriority {
    return ^BMConstraint *(UILayoutPriority priority) {
        [self.delegate setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
        return self;
    };
}

- (BMConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (BMConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (BMConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (BMConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (BMConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (BMConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (BMConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (BMConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (BMConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (BMConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (BMConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (BMConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

- (BMConstraint * (^)(id key))key { BMMethodNotImplemented(); }

- (BMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute { BMMethodNotImplemented(); }

- (void)install { BMMethodNotImplemented(); }

- (void)uninstall { BMMethodNotImplemented(); }

@end

