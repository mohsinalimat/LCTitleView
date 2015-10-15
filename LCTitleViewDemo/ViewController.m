//
//  ViewController.m
//  LCTitleViewDemo
//
//  Created by bawn on 10/13/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "MSTitleView.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet MSTitleView *titleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.titleArray = @[@"红星午餐", @"小食", @"甜点", @"酱料", @"下午茶",@"• • •"];
    self.titleView.buttonNormalColor = [UIColor redColor];
    self.titleView.buttonSelectedColor = [UIColor blackColor];
    self.titleView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
