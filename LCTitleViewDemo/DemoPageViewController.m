//
//  DemoPageViewController.m
//  LCTitleViewDemo
//
//  Created by bawn on 10/28/15.
//  Copyright © 2015 huoqiu. All rights reserved.
//

#import "DemoPageViewController.h"
#import "LCTitleView.h"

@interface DemoPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, LCTitleViewDelegate>

@property (nonatomic, strong) NSArray *viewControllerArray;
@property (nonatomic, strong) IBOutlet LCTitleView *titleView;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, assign, getter=isPageScrollingFlag) BOOL pageScrollingFlag;

@end

@implementation DemoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIViewController *vc1 = [[UIViewController alloc] init];
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc2.view.backgroundColor = [UIColor blueColor];
    self.viewControllerArray = @[vc1, vc2];
    [self setViewControllers:@[_viewControllerArray.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];

    [self syncScrollView];
    self.delegate = self;
    self.dataSource = self;
    
    self.titleView.titleArray = @[@"午餐", @"早餐"];
    self.titleView.buttonNormalColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f];
    self.titleView.buttonSelectedColor = [UIColor colorWithRed:33.0f/255.0f green:175.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
    self.titleView.showSelectionBar = YES;
    self.titleView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)syncScrollView {
    for (UIView* view in self.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
            break;
        }
    }
}


- (void)titleView:(LCTitleView *)titleView didButtonClick:(UIButton *)button{
    if (!self.isPageScrollingFlag) {
        
        __weak typeof(self) weakSelf = self;
        BOOL navigationDirection = button.tag > self.titleView.currentIndex;
        
        [self setViewControllers:@[self.viewControllerArray[button.tag]] direction:navigationDirection ?UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
            if (complete) {
                weakSelf.titleView.currentIndex = button.tag;
            }
        }];
    }
}


#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageScrollingFlag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageScrollingFlag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat xOffset = scrollViewWidth - scrollView.contentOffset.x;
    CGFloat rate = (_titleView.currentIndex * scrollViewWidth - xOffset)/scrollViewWidth;
    self.titleView.selectionMoveRate = @(rate);
    
}

#pragma mark - UIPageViewController Delegate Method


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [_viewControllerArray indexOfObject:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    index--;
    return [_viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [_viewControllerArray indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == _viewControllerArray.count) {
        return nil;
    }
    return _viewControllerArray[index];
}



- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.titleView.currentIndex = [_viewControllerArray indexOfObject:[pageViewController.viewControllers lastObject]];
    }
}





@end
