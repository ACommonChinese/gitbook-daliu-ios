//
//  ViewController.m
//  DrawLine
//
//  Created by 刘威振 on 2020/5/18.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import "DL24HourCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:DL24HourCell.class forCellReuseIdentifier:@"DL24HourCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DL24HourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DL24HourCell" forIndexPath:indexPath];
    [cell set24HoureCellWithModel:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 233;
}

@end
