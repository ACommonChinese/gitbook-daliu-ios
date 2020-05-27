//
//  TestCell.m
//  DidMoveTo
//
//  Created by 刘威振 on 2020/5/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didMoveToSuperview {
    NSLog(@"HERE -- %@", self.indexPath);
}

@end
