//
//  ViewController.m
//  DidMoveTo
//
//  Created by 刘威振 on 2020/5/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import "TestCell.h"
#import "SecondVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:TestCell.class forCellReuseIdentifier:NSStringFromClass(TestCell.class)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = (TestCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TestCell.class) forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.indexPath = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondVC *vc = [[SecondVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
