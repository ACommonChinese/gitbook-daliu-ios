//
//  UIImage+Addition.m
//  FinanceCar
//
//  Created by mac on 2019/9/17.
//  Copyright © 2019年 NingXiaHaiShengTong. All rights reserved.
//

#import "UIImage+Addition.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Addition)

+ (UIImage *)imageWithColor:(UIColor*)color rect:(CGRect)rect {
    CGRect imgRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imgRect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)imageWithRgba:(CGFloat*)rgba rect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace,rgba);
    UIColor *color = [[UIColor alloc]initWithCGColor:colorRef];
    CGColorRelease(colorRef);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithColor:color rect:rect];
}

+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    
    //先调整分辨率
    
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    
    
    CGFloat tempHeight = newSize.height / 1024;
    
    CGFloat tempWidth = newSize.width / 1024;
    
    
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
        
    }
    
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
        
    }
    
    
    
    UIGraphicsBeginImageContext(newSize);
    
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    //调整大小
    
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    
    NSUInteger sizeOrigin = [imageData length];
    
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    
    if (sizeOriginKB > maxSize) {
        
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        
        return finallImageData;
        
    }
    
    
    
    return imageData;
    

}


- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(GradientType)gradientType {
    
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
//    NSUInteger capacity = percents.count;
//    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case GradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case GradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case GradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur{
    
    
    
    return image;
}


@end
