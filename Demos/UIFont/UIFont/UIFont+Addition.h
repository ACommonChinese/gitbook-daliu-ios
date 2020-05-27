//
//  UIFont+Addition.h
//  UIFont
//
//  Created by 刘威振 on 2020/5/14.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition)

/// DIN-Medium
+ (UIFont *)dl_dinMedium:(CGFloat)size;

/// DIN-Regular
+ (UIFont *)dl_dinRegular:(CGFloat)size;

/// DIN-Light
+ (UIFont *)dl_dinLight:(CGFloat)size;

 /// Roboto-Litght
+ (UIFont *)dl_robotoLight:(CGFloat)size;

/// Roboto-Regular
+ (UIFont *)dl_robotoRegular:(CGFloat)size;

/// 宫书缩小字体
+ (UIFont *)dl_sourceHanSerifSCHeavy:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
