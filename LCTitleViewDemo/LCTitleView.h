//
//  LCTitleView.h
//  LCTitleViewDemo
//
//  Created by bawn on 9/25/15.
//  Copyright © 2015 https://github.com/bawn . All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTitleView;
@protocol LCTitleViewDelegate <NSObject>

- (void)titleView:(LCTitleView *)titleView didButtonClick:(UIButton *)button;

@end

@interface LCTitleView : UIView

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) CGFloat margin;// 左右边距
@property (nonatomic, strong) UIFont  *buttonFont;// button字体
@property (nonatomic, assign) CGFloat buttonInsets;// button的左右宽度偏移量，为了加宽点击范围
@property (nonatomic, strong) UIColor *buttonNormalColor;
@property (nonatomic, strong) UIColor *buttonSelectedColor;
@property (nonatomic, strong) UIColor *bottomLineColor;// 底部线的颜色
@property (nonatomic, assign, getter=isShowBottomLine) BOOL showBottomLine;// 是否显示底部的0.5像素的线
@property (nonatomic, strong) UIColor *selectionColor;// 默认和 buttonSelectedColor 相同
@property (nonatomic, assign) CGFloat selectionWidthScale;// selectionBar 相对于button 宽度的比例，默认 1.2
@property (nonatomic, assign, getter=isShowSelectionBar) BOOL showSelectionBar;// 是否显示 showSelectionBar，默认动画
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) UIScrollView *targetScrollView;
@property (nonatomic, weak) id <LCTitleViewDelegate> delegate;

- (instancetype)initWithTitls:(NSArray *)titlsArray clickBlock:(void (^) (UIButton *button))block;

@end
