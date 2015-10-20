//
//  ViewController.m
//  LCTitleViewDemo
//
//  Created by bawn on 10/13/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "LCTitleView.h"
#import <Masonry.h>

@interface ViewController ()<LCTitleViewDelegate>

@property (nonatomic, strong) IBOutlet LCTitleView *titleView;
@property (nonatomic, strong) IBOutlet UISlider *fontSlider;
@property (nonatomic, strong) IBOutlet UISlider *marginSlider;
@property (nonatomic, strong) IBOutlet UILabel *fontLabel;
@property (nonatomic, strong) IBOutlet UILabel *marginLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.titleArray = @[@"午餐", @"小食", @"甜点甜点", @"酱料", @"下午茶",@"早餐"];
    self.titleView.buttonNormalColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f];
    self.titleView.buttonSelectedColor = [UIColor colorWithRed:33.0f/255.0f green:175.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
    self.titleView.buttonFont = [UIFont systemFontOfSize:13.0f];
//    self.titleView.buttonInsets = 10.0f;
    self.titleView.margin = 10.0f;
    self.titleView.showSelectionBar = YES;
    self.titleView.delegate = self;

    self.titleView.backgroundColor = [UIColor whiteColor];
}


- (IBAction)fontSliderAction:(id)sender{
    UISlider *slider = (UISlider *)sender;
    self.fontLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    self.titleView.buttonFont = [UIFont systemFontOfSize:slider.value];
}

- (IBAction)marginSliderAction:(id)sender{
    UISlider *slider = (UISlider *)sender;
    self.marginLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    self.titleView.margin = slider.value;
}

- (IBAction)changeTitlesAction:(id)sender{
    self.titleView.titleArray = @[@"酱料", @"小食", @"小食", @"酱料", @"午餐",@"下午茶"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LCTitleViewDelegate Method

- (void)titleView:(LCTitleView *)titleView didButtonClick:(UIButton *)button{
    NSLog(@"%d", button.tag);
}


@end
