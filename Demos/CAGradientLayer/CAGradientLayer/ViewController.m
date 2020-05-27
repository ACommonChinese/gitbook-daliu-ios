//
//  ViewController.m
//  CAGradientLayer
//
//  Created by 刘威振 on 2020/5/18.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CAGradientLayer *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CAGradientLayer *)layer {
    if (!_layer) {
        CAGradientLayer *layer = [CAGradientLayer layer];

        CGRect rect = CGRectMake(5, 5, self.imageView.bounds.size.width - 10, self.imageView.bounds.size.height - 10);

        layer.frame = rect; // self.imageView.bounds;
        layer.startPoint = CGPointMake(0.5, 0);
        layer.endPoint = CGPointMake(0.5, 1);

        layer.colors = @[(__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.16].CGColor, (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor];
        layer.locations = @[@(0), @(0.5f), @(1.0f)];
        self.layer = layer;
    }
    return _layer;
}

- (IBAction)addGradientLayer:(id)sender {
    [self.imageView.layer addSublayer:self.layer];
}

- (IBAction)removeLayer:(id)sender {
    [self.layer removeFromSuperlayer];
}

@end
