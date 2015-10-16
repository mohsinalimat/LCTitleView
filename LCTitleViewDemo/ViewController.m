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
    self.titleView.buttonNormalColor = [UIColor whiteColor];
    self.titleView.buttonSelectedColor = [UIColor blackColor];
    self.titleView.backgroundColor = [UIColor grayColor];
    self.titleView.buttonFont = [UIFont systemFontOfSize:13.0f];
    self.titleView.buttonInsets = 10.0f;
    self.titleView.contentWidth = 300.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
