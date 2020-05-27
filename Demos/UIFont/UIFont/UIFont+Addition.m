//
//  UIFont+Addition.m
//  UIFont
//
//  Created by 刘威振 on 2020/5/14.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "UIFont+Addition.h"

@implementation UIFont (Addition)

/// DIN-Medium
+ (UIFont *)dl_dinMedium:(CGFloat)size {
    return [UIFont fontWithName:@"DIN-Medium" size:size];
}

/// DIN-Regular
+ (UIFont *)dl_dinRegular:(CGFloat)size {
    return [UIFont fontWithName:@"DIN-Regular" size:size];
}

/// DIN-Light
+ (UIFont *)dl_dinLight:(CGFloat)size {
    return [UIFont fontWithName:@"DIN-Light" size:size];
}

 /// Roboto-Litght
+ (UIFont *)dl_robotoLight:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}

/// Roboto-Regular
+ (UIFont *)dl_robotoRegular:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Regular" size:size];
}

+ (UIFont *)dl_sourceHanSerifSCHeavy:(CGFloat)size {
    return [UIFont fontWithName:@"SourceHanSerifSC-Heavy" size:size];
}

@end
