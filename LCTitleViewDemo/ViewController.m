//
//  ViewController.m
//  LCTitleViewDemo
//
//  Created by bawn on 10/13/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "MSTitleView.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) IBOutlet MSTitleView *titleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.titleArray = @[@"午餐", @"小食", @"甜点", @"酱料", @"下午茶",@"早餐"];
    self.titleView.buttonNormalColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f];
    self.titleView.buttonSelectedColor = [UIColor colorWithRed:33.0f/255.0f green:175.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
    self.titleView.buttonFont = [UIFont systemFontOfSize:13.0f];
//    self.titleView.buttonInsets = 10.0f;
    self.titleView.margin = 10.0f;
    self.titleView.showSelectionBar = YES;

    self.titleView.backgroundColor = [UIColor whiteColor];
}

- (void)titleButtonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    button.highlighted = button.selected;;
    NSLog(@"%d",button.selected);
}


- (IBAction)changeTtitleView:(id)sender{
    self.titleView.buttonFont = [UIFont systemFontOfSize:15.0f];
    self.titleView.selectionOffsetWidth = 15.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
