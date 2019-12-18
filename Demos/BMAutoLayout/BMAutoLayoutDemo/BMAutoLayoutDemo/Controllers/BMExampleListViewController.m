//
//  BMExampleListViewController.m
//  NSLayoutAnchor
//
//  Created by liuweizhen on 2018/9/14.
//  Copyright © 2018年 liuxing8807@126.com All rights reserved.
//

#import "BMExampleListViewController.h"
#import "BMExampleViewController.h"
#import "BMExampleBasicView.h"
#import "BMExampleUpdateView.h"
#import "BMExampleRemakeView.h"
#import "BMExampleConstantsView.h"
#import "BMExampleSidesView.h"
#import "BMExampleAspectFitView.h"
#import "BMExampleAnimatedView.h"
#import "BMExampleLabelView.h"
#import "BMExampleScrollView.h"
#import "BMExampleArrayView.h"
#import "BMExampleAttributeChainingView.h"
#import "BMExampleDistributeView.h"

static NSString * const kBMCellReuseIdentifier = @"kBMCellReuseIdentifier";

@interface BMExampleListViewController ()

@property (nonatomic, strong) NSArray *exampleControllers;

@end

@implementation BMExampleListViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.title = @"Examples";
    
    self.exampleControllers = @[
                                [[BMExampleViewController alloc] initWithTitle:@"Basic"
                                                                      viewClass:BMExampleBasicView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Update Constraints"
                                                                      viewClass:BMExampleUpdateView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Remake Constraints"
                                                                      viewClass:BMExampleRemakeView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Using Constants"
                                                                      viewClass:BMExampleConstantsView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Composite Edges"
                                                                      viewClass:BMExampleSidesView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Aspect Fit"
                                                                      viewClass:BMExampleAspectFitView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Basic Animated"
                                                                      viewClass:BMExampleAnimatedView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Bacony Labels"
                                                                      viewClass:BMExampleLabelView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"UIScrollView"
                                                                      viewClass:BMExampleScrollView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Array"
                                                                      viewClass:BMExampleArrayView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Attribute Chaining"
                                                                      viewClass:BMExampleAttributeChainingView.class],
                                [[BMExampleViewController alloc] initWithTitle:@"Views Distribute"
                                                                      viewClass:BMExampleDistributeView.class],
                                
                                ];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kBMCellReuseIdentifier];
}

#pragma mark - Table view data source


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.exampleControllers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBMCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = viewController.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exampleControllers.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.exampleControllers[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
