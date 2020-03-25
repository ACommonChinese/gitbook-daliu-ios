//
//  ViewController.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "ViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@interface BMModuleKitDemoItem : NSObject

//  @property title
@property (nonatomic, copy) NSString *title;

//  @property subTitle
@property (nonatomic, copy) NSString *subTitle;

@end

#pragma mark -

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

//  @property tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//  @property items;
@property (nonatomic, strong) NSMutableArray<BMModuleKitDemoItem *> *items;

@end

#pragma mark -

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"BMModuleKit Demo";
    
    // Initialization
    _items = [NSMutableArray<BMModuleKitDemoItem *> array];
    NSArray<NSString *> *titles = @[@"Message", @"Friends", @"Profile", @"Shopping", @"Detail"];
    for (NSInteger i = 0; i < titles.count; ++i) {
        BMModuleKitDemoItem *item = [[BMModuleKitDemoItem alloc] init];
        item.title = [NSString stringWithFormat:@"Module - %@", titles[i]];
        item.subTitle = [NSString stringWithFormat:@"Goto : %@", titles[i]];
        [_items addObject:item];
    }
    
    // Table datasource & delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    BMModuleKitDemoItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIViewController *messageVC =
            (__bridge UIViewController *)(@module_call(BMModuleMessage.messageViewController));
        if (messageVC && [messageVC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:messageVC animated:YES];
        }
    }
    else if (indexPath.row == 1) {
        UIViewController *friendsVC =
        (__bridge UIViewController *)(@module_call(BMModuleFriends.friendsViewController));
        if (friendsVC && [friendsVC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:friendsVC animated:YES];
        }
    }
    else if (indexPath.row == 2) {
        UIViewController *profileVC =
        (__bridge UIViewController *)(@module_call(BMModuleProfile.profileViewController));
        if (profileVC && [profileVC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:profileVC animated:YES];
        }
    }
    else if (indexPath.row == 3) {
        UIViewController *shoppingVC =
        (__bridge UIViewController *)(@module_call(BMModuleShopping.shoppingViewController));
        if (shoppingVC && [shoppingVC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:shoppingVC animated:YES];
        }
    }
    else if (indexPath.row == 4) {
        UIViewController *detailVC =
        (__bridge UIViewController *)(@module_call(BMDetailModule.detailViewController));
        if (detailVC && [detailVC isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

@end

#pragma mark -

@implementation BMModuleKitDemoItem

@end

