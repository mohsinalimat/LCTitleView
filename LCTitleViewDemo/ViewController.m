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

@interface ViewController ()<LCTitleViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet LCTitleView *titleView;
@property (nonatomic, strong) IBOutlet UISlider *fontSlider;
@property (nonatomic, strong) IBOutlet UISlider *marginSlider;
@property (nonatomic, strong) IBOutlet UILabel *fontLabel;
@property (nonatomic, strong) IBOutlet UILabel *marginLabel;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = @[@"午餐", @"小食", @"甜点甜点", @"酱料", @"下午茶",@"早餐"];
    self.titleView.titleArray = _titleArray;
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
    self.titleArray = @[@"酱料", @"小食", @"小食", @"酱料", @"午餐",@"下午茶"];
    self.titleView.titleArray = _titleArray;
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LCTitleViewDelegate Method

- (void)titleView:(LCTitleView *)titleView didButtonClick:(UIButton *)button{
    NSLog(@"%d", button.tag);
}


#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (!cell.contentView.subviews.count) {
        UILabel *label = [[UILabel alloc] init];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0.0f);
        }];
        label.font = [UIFont systemFontOfSize:26.0f];
    }
    UILabel *label = cell.contentView.subviews.firstObject;
    label.text= [@(indexPath.row)  stringValue];
    return cell;
}

@end
