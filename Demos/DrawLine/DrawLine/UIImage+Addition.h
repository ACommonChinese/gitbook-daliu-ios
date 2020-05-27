//
//  UIImage+Addition.h
//  FinanceCar
//
//  Created by mac on 2019/9/17.
//  Copyright © 2019年 NingXiaHaiShengTong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从左到右
    GradientFromLeftTopToRightBottom,       //从上到下
    GradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (Addition)


/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents          渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;

+ (UIImage *)imageWithColor:(UIColor*)color rect:(CGRect)rect;

+ (UIImage *)imageWithRgba:(CGFloat*)rgba rect:(CGRect)rect;

+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;

/** Attention points:传入图片返回设置毛玻璃效果后的图片
 ① 需要引入#import <Accelerate/Accelerate.h>
 ② 传入变量 blur 代表毛玻璃设置的程度，值越大越模糊 范围须在0-1中间,默认为0.5
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end

NS_ASSUME_NONNULL_END
