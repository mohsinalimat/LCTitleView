//
//  MSTitleView.h
//  MishiOS
//
//  Created by bawn on 9/25/15.
//  Copyright © 2015 ___MISHI___. All rights reserved.
//
//  标题选择视图
#import <UIKit/UIKit.h>
IB_DESIGNABLE
@class MSTitleView;
@protocol MSTitleViewDelegate <NSObject>

- (void)titleView:(MSTitleView *)titleView didButtonClick:(UIButton *)button;

@end

@interface MSTitleView : UIView

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) CGFloat margin;// 左右边距
@property (nonatomic, strong) UIFont  *buttonFont;// button字体
@property (nonatomic, assign) CGFloat buttonInsets;// button的左右宽度偏移量，为了加宽点击范围
@property (nonatomic, strong) UIColor *buttonNormalColor;
@property (nonatomic, strong) UIColor *buttonSelectedColor;

@property (nonatomic, strong) UIColor *bottomLineColor;// 底部线的颜色
@property (nonatomic, assign, getter=isShowBottomLine) BOOL showBottomLine;// 是否显示底部的线
@property (nonatomic, strong) UIColor *selectionColor;// 默认和 buttonSelectedColor 相同
@property (nonatomic, assign) CGFloat selectionOffsetWidth;// selectionBar 的偏移宽度
@property (nonatomic, assign, getter=isShowSelectionBar) BOOL showSelectionBar;// 是否显示 showSelectionBar
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id <MSTitleViewDelegate> delegate;

- (instancetype)initWithTitls:(NSArray *)titlsArray clickBlock:(void (^) (UIButton *button))block;
//- (void)changTitles:(NSArray<NSString *> *)titles atIndexs:(NSArray<NSNumber *> *)indexs;
//- (void)changButtonSelectedColors:(NSArray<UIColor *> *)colors atIndexs:(NSArray<NSNumber *> *)indexs;

@end
