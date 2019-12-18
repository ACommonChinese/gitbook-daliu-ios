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

#import "BMViewConstraint.h"
#import "BMConstraint+Private.h"
#import <objc/runtime.h>
#import "BMCompositeConstraint.h"
#import "UIView+BMAdditions.h"

@interface BMViewConstraint ()

@property (nonatomic, assign) UILayoutPriority layoutPriority;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) BOOL hasLayoutRelation;
@property (nonatomic, weak) NSLayoutConstraint *layoutConstraint;
@property (nonatomic, strong) id bm_key;

@end

@implementation BMViewConstraint

- (id)initWithAttribute:(NSLayoutAttribute)attribute anchor:(NSLayoutAnchor *)anchor {
    self = [super init];
    if (!self) return nil;
    
    _attribute = attribute;
    _firstAnchor = anchor;
    self.layoutPriority = UILayoutPriorityRequired;
    self.multiplier = 1;
    
    return self;
}

+ (NSLayoutAnchor *)matchedAnchorForView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute {
    switch (layoutAttribute) {
        case NSLayoutAttributeLeading:       return view.leadingAnchor;
        case NSLayoutAttributeLeft:          return view.leftAnchor;
        case NSLayoutAttributeTrailing:      return view.trailingAnchor;
        case NSLayoutAttributeRight:         return view.rightAnchor;
        case NSLayoutAttributeTop:           return view.topAnchor;
        case NSLayoutAttributeBottom:        return view.bottomAnchor;
        case NSLayoutAttributeWidth:         return view.widthAnchor;
        case NSLayoutAttributeHeight:        return view.heightAnchor;
        case NSLayoutAttributeCenterX:       return view.centerXAnchor;
        case NSLayoutAttributeCenterY:       return view.centerYAnchor;
        case NSLayoutAttributeFirstBaseline: return view.firstBaselineAnchor;
        case NSLayoutAttributeLastBaseline:  return view.lastBaselineAnchor;
        default:
            break;
    }
    return nil;
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(UIEdgeInsets)insets {
    switch (self.attribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
            self.constant = insets.left;
            break;
        case NSLayoutAttributeTop:
            self.constant = insets.top;
            break;
        case NSLayoutAttributeBottom:
            self.constant = -insets.bottom;
            break;
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
            self.constant = -insets.right;
            break;
        default:
            break;
    }
}

- (void)setInset:(CGFloat)inset {
    [self setInsets:(UIEdgeInsets){.top = inset, .left = inset, .bottom = inset, .right = inset}];
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    switch (self.attribute) {
        case NSLayoutAttributeWidth:
            self.constant = sizeOffset.width;
            break;
        case NSLayoutAttributeHeight:
            self.constant = sizeOffset.height;
            break;
        default:
            break;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    switch (self.attribute) {
        case NSLayoutAttributeCenterX:
            self.constant = centerOffset.x;
            break;
        case NSLayoutAttributeCenterY:
            self.constant = centerOffset.y;
            break;
        default:
            break;
    }
}

- (void)setOffset:(CGFloat)offset {
    self.constant = offset;
}

- (BMConstraint *(^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");
        
        self.multiplier = multiplier;
        return self;
    };
}

- (BMConstraint *(^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");
        
        self.multiplier = 1.0/divider;
        return self;
    };
}

- (BMConstraint *(^)(UILayoutPriority))priority {
    return ^id(UILayoutPriority priority) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint priority after it has been installed");
        
        self.layoutPriority = priority;
        return self;
    };
}

- (BMConstraint *(^)(void))priorityLow {
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

- (BMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSAssert(!self.hasLayoutRelation, @"Attributes should be chained before defining the constraint relation");
    return [self.delegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
}


// take example:
// attribute: UIView, NSValue, NSArray
// relation: >= = <=
// make.top.equalTo(100)
// make.top.equalTo(view2.bottomAnchor)
// make.top.equalTo(view2.topAnchor)
// make.top.equalTo(view2);
// make.top.greaterThanOrEqualTo(view2.bottomAnchor)
// make.height.equalTo(@[view2.heightAnchor, view3.heightAnchor, view4.heightAnchor])
// make.height.equalTo(@[view2, view3, view4])
- (BMConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        if ([attribute isKindOfClass:NSArray.class]) {
            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
            NSMutableArray *children = NSMutableArray.new;
            for (id anchor in attribute) {
                BMViewConstraint *viewConstraint = [self copy];
                viewConstraint.relation = relation;
                if ([anchor isKindOfClass:NSLayoutAnchor.class]) {
                    viewConstraint->_secondAnchor = anchor;
                } else if ([anchor isKindOfClass:UIView.class]) {
                    NSLayoutAnchor *secondAnchor = [BMViewConstraint matchedAnchorForView:(UIView *)anchor attribute:self.attribute];
                    NSAssert(secondAnchor, @"can't get matched secondAnchor: %@ attribute: %d", anchor, (int)self.attribute);
                    viewConstraint->_secondAnchor = secondAnchor;
                } else {
                    NSAssert(NO, @"attempting to add unsupported attribute: %@", anchor);
                }

                [children addObject:viewConstraint];
            }
            BMCompositeConstraint *compositeConstraint = [[BMCompositeConstraint alloc] initWithChildren:children];
            compositeConstraint.delegate = self.delegate;
            [self.delegate constraint:self shouldBeReplacedWithConstraint:compositeConstraint];
            return compositeConstraint;
        } else {
            NSAssert(!self.hasLayoutRelation || self.relation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
            self.relation = relation;
            [self setSecondAttribute:attribute];
        }
        return self;
    };
}

- (NSLayoutConstraint *)getLayoutConstraint {
    NSLayoutConstraint *layoutConstraint;
    
    if ([self isSizeConstraint]) {//width & height can not have secondAnchor
        NSLayoutDimension *firstAnchor = (NSLayoutDimension *)self.firstAnchor;
        NSLayoutDimension *secondAnchor = (NSLayoutDimension *)self.secondAnchor;
        switch (self.relation) {
            case NSLayoutRelationEqual: {
                layoutConstraint = self.secondAnchor ? [firstAnchor constraintEqualToAnchor:secondAnchor multiplier:self.multiplier constant:self.constant] : [firstAnchor constraintEqualToConstant:self.constant];
                break;
            }
            case NSLayoutRelationGreaterThanOrEqual: {
                layoutConstraint = self.secondAnchor ? [firstAnchor constraintGreaterThanOrEqualToAnchor:secondAnchor multiplier:self.multiplier constant:self.constant] : [firstAnchor constraintGreaterThanOrEqualToConstant:self.constant];
                break;
            }
            case NSLayoutRelationLessThanOrEqual: {
                layoutConstraint = self.secondAnchor ? [firstAnchor constraintLessThanOrEqualToAnchor:secondAnchor multiplier:self.multiplier constant:self.constant] : [firstAnchor constraintLessThanOrEqualToConstant:self.constant];
                break;
            }
            default:
                break;
        }
    }
    else {
        if (!self.secondAnchor) {
            _secondAnchor = [BMViewConstraint matchedAnchorForView:self.firstAnchorView.superview attribute:self.attribute];
        }
        switch (self.relation) {
            case NSLayoutRelationEqual: {
                layoutConstraint = [self.firstAnchor constraintEqualToAnchor:self.secondAnchor constant:self.constant];
                break;
            }
            case NSLayoutRelationGreaterThanOrEqual: {
                layoutConstraint = [self.firstAnchor constraintGreaterThanOrEqualToAnchor:self.secondAnchor constant:self.constant];
                break;
            }
            case NSLayoutRelationLessThanOrEqual: {
                layoutConstraint = [self.firstAnchor constraintLessThanOrEqualToAnchor:self.secondAnchor constant:self.constant];
                break;
            }
            default:
                break;
        }
    }
    
    layoutConstraint.priority = self.layoutPriority;
    
    return layoutConstraint;
}

- (void)install {
    if (self.hasBeenInstalled) {
        return;
    }
    
    if (self.layoutConstraint) {
        self.layoutConstraint.active = YES;
        [self.firstAnchorView.bm_installedConstraints addObject:self];
        return;
    }
    
    NSLayoutConstraint *layoutConstraint = [self getLayoutConstraint];
    
    BMViewConstraint *existingConstraint = nil;
    if (self.updateExisting) {
        existingConstraint = [self similiarViewConstraint];
    }
    if (existingConstraint) {
        // just update the constant
        existingConstraint.layoutConstraint.constant = self.constant;
    }
    else {
        self.layoutConstraint = layoutConstraint;
        self.layoutConstraint.active = YES;
        [self.firstAnchorView.bm_installedConstraints addObject:self];
    }
}

- (BMViewConstraint *)similiarViewConstraint {
    for (BMConstraint *constraint in self.firstAnchorView.bm_installedConstraints) {
        if (![constraint isKindOfClass:[BMViewConstraint class]]) {
            continue;
        }
        BMViewConstraint *existingConstraint = (BMViewConstraint *)constraint;
        if (existingConstraint.firstAnchor != self.firstAnchor) continue;
        if (existingConstraint.secondAnchor != self.secondAnchor) continue;
        if (existingConstraint.relation != self.relation) continue;
        if (existingConstraint.multiplier != self.multiplier) continue;
        
        return existingConstraint;
    }
    return nil;
}

- (BOOL)isSizeConstraint {
    return self.attribute == NSLayoutAttributeWidth || self.attribute == NSLayoutAttributeHeight;
}

- (void)uninstall {
    self.layoutConstraint.active = NO;
    [self.firstAnchorView.bm_installedConstraints removeObject:self];
}

- (void)setSecondAttribute:(id)attribute {
    if ([attribute isKindOfClass:NSValue.class]) {
        [self setLayoutConstantWithValue:attribute];
    } else if ([attribute isKindOfClass:UIView.class]) {
        _secondAnchor = [BMViewConstraint matchedAnchorForView:attribute attribute:self.attribute];
    } else if ([attribute isKindOfClass:NSLayoutAnchor.class]) {
        _secondAnchor = attribute;
    } else {
        NSAssert(NO, @"attempting to add unsupported attribute: %@", attribute);
    }
}

#pragma mark - debug helpers

- (BMConstraint * (^)(id))key {
    return ^id(id key) {
        self.bm_key = key;
        return self;
    };
}

#pragma mark - Public

#pragma mark - NSCoping

- (id)copyWithZone:(NSZone __unused *)zone {
    BMViewConstraint *constraint = [[BMViewConstraint alloc] initWithAttribute:self.attribute anchor:nil];
    constraint->_firstAnchor = self.firstAnchor;
    constraint.constant = self.constant;
    constraint.relation = self.relation;
    constraint.layoutPriority = self.layoutPriority;
    constraint.multiplier = self.multiplier;
    constraint.delegate = self.delegate;
    constraint.firstAnchorView = self.firstAnchorView;
    return constraint;
}

#pragma mark - Private

- (void)setConstant:(CGFloat)constant {
    _constant = constant;
    self.layoutConstraint.constant = constant;
}

- (void)setRelation:(NSLayoutRelation)relation {
    _relation = relation;
    self.hasLayoutRelation = YES;
}

- (BOOL)isActive {
    return self.layoutConstraint.isActive;
}

- (BOOL)hasBeenInstalled {
    return (self.layoutConstraint != nil) && [self isActive];
}

- (NSString *)description {
    if (self.bm_key) {
        return [NSString stringWithFormat:@"%p - %@", self, self.bm_key];
    }
    else {
        return [super description];
    }
}

@end
