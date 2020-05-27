//
//  UIView+Addition.m
//  FinanceCar
//
//  Created by mac on 2019/9/17.
//  Copyright © 2019年 NingXiaHaiShengTong. All rights reserved.
//

#import "UIView+Addition.h"


@implementation UIView (Addition)


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}


- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)centerX {
    return self.center.x;
}


- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY {
    return self.center.y;
}


- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size {
    return self.frame.size;
}


- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX
{
    [self setOrigin:CGPointMake(originX, self.frame.origin.y)];
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY
{
    [self setOrigin:CGPointMake(self.frame.origin.x, originY)];
}

- (CGImageRef) createGradientImage: (CGSize)size
{
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // Create gradient in gray device color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    //    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // Draw the linear gradient
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(0, size.height);
    CGContextDrawLinearGradient(context, gradient, p1, p2, kCGGradientDrawsAfterEndLocation);
    
    // Return the CGImage
    CGImageRef theCGImage = CGBitmapContextCreateImage(context);
    CFRelease(gradient);
    CGContextRelease(context);
    UIImage *image = [UIImage imageWithCGImage:theCGImage];
    CGImageRelease(theCGImage);
    return image.CGImage;
}

- (UIImage *) reflectionOfView: (UIView *)theView withPercent: (CGFloat) percent
{
    // Retain the width but shrink the height
    CGSize size = CGSizeMake(theView.frame.size.width, theView.frame.size.height * percent);
    
    // Shrink the view
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *partialimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // build the mask
    CGImageRef mask = [self createGradientImage:size];
    CGImageRef ref = CGImageCreateWithMask(partialimg.CGImage, mask);
    UIImage *theImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return theImage;
}

const CGFloat kReflectDistance = 1.0f;

- (void) addReflection
{
    self.clipsToBounds = NO;
    UIImageView *reflection = [[UIImageView alloc] initWithImage:[self reflectionOfView: self withPercent: 0.3f]];
    CGRect frame = reflection.frame;
    frame.origin = CGPointMake(0.0f, self.frame.size.height + kReflectDistance);
    reflection.frame = frame;
    
    [self addSubview:reflection];
}

const CGFloat kReflectPercent = 0.5f;
const CGFloat kReflectOpacity = 0.5f;

- (void) addSimpleReflection
{
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = [self layer].contents;
    reflectionLayer.opacity = kReflectOpacity;
    reflectionLayer.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height * kReflectPercent);
    CATransform3D stransform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
    CATransform3D transform = CATransform3DTranslate(stransform, 0.0f, -(kReflectDistance + self.frame.size.height), 0.0f);
    reflectionLayer.transform = transform;
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    [[self layer] addSublayer:reflectionLayer];
}


- (void)addShapeLineWithlineColor:(UIColor *)lineColor{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.width;
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width, self.height)];
     
    CAShapeLayer *_shapeLine = [CAShapeLayer layer];
    _shapeLine.frame = self.bounds;
    // _shapeLine.lineJoin = kCALineJoinRound;
    _shapeLine.lineDashPattern = @[@(2),@(2)];
    _shapeLine.fillColor = [UIColor clearColor].CGColor;
    _shapeLine.strokeColor = lineColor.CGColor;
    _shapeLine.path = path.CGPath;
    [self.layer addSublayer:_shapeLine];
}


- (void) clipViewWithRadius: (CGFloat)radius;
{
    CALayer *layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
}

- (void)addTarget:(id)target action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (UIView *)gradientViewWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    UIImage *backImage = [[UIImage alloc] createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    [self setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
    return self;
}

- (UIViewController*)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end


@implementation UIImageView (Additions)

- (void) clipToCircleWithShadow
{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2;
    
    // round
    [self clipViewWithRadius: self.frame.size.width/2];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setImage: viewImage];
    
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 0.8f;
    
    self.clipsToBounds = NO;
}

- (void) clipViewWithShadowAndRadius: (CGFloat) radius borderColor:(CGColorRef) borderColor
{
    self.layer.borderColor = borderColor;
    self.layer.borderWidth = 1.f;
    
    [self clipViewWithRadius: radius];
    
    //UIGraphicsBeginImageContext(self.frame.size);
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setImage: viewImage];
    
    //    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    //    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    //    self.layer.shadowOpacity = 0.8f;
    
    self.clipsToBounds = NO;
}





@end


@implementation UIButton (Additions)

- (void) clipToCircleWithShadow
{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2;
    
    // round
    [self clipViewWithRadius: self.frame.size.width/2];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage: viewImage forState: UIControlStateNormal];
    
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 0.8f;
    
    self.clipsToBounds = NO;
}

- (void) clipViewWithShadowAndRadius: (CGFloat) radius
{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2;
    
    [self clipViewWithRadius: radius];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage: viewImage forState: UIControlStateNormal];
    
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 0.8f;
    
    self.clipsToBounds = NO;
}


@end
