//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by 刘威振 on 2020/7/31.
//  Copyright © 2020 大刘. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JKWWebView Demo";
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cellID"];
    self.items = @[
        @"进度条",
        @"JS交互"
    ];
}

// MARK: - <UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.items objectAtIndex:indexPath.row];
    if ([text isEqualToString:@"进度条"]) {
        
    } else if ([text isEqualToString:@"JS交互"]) {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
