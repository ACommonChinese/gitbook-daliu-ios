//
//  SecondVC.m
//  DidMoveTo
//
//  Created by 刘威振 on 2020/5/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "SecondVC.h"
#import "PurpleView.h"

@interface SecondVC ()

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    [self.view addSubview:scrollView];
    
    PurpleView *purpleView = [[PurpleView alloc] initWithFrame:CGRectMake(30, 60, 200, 200)];
    purpleView.backgroundColor = [UIColor purpleColor];
    [scrollView addSubview:purpleView];
}

@end
