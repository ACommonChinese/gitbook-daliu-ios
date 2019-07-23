//
//  ViewController.m
//  LocalFilePodDemo
//
//  Created by liuweizhen on 2019/3/29.
//  Copyright © 2019 daliu. All rights reserved.
//

#import "ViewController.h"
#import <AnimalKit/Cat.h>
#import <AnimalKit/Person.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Cat *cat = Cat.new;
    [cat eat];
    [cat drink];
    [cat think];
    
    Person *p = Person.new;
    [p eat];
    [p drink];
    [p think];
}


@end
