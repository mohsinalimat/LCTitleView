//
//  MSTitleView.h
//  MishiOS
//
//  Created by bawn on 9/25/15.
//  Copyright © 2015 ___MISHI___. All rights reserved.
//
//  标题选择视图
#import <UIKit/UIKit.h>

@class MSTitleView;
@protocol MSTitleViewDelegate <NSObject>

- (void)titleView:(MSTitleView *)titleView didButtonClick:(UIButton *)button;

@end

@interface MSTitleView : UIView

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *normalImages;
@property (nonatomic, strong) NSArray *selectedImages;
@property (nonatomic, assign) CGFloat betweenMargin;// button 的间距
@property (nonatomic, assign) CGFloat buttonInsets;// button的左右宽度偏移量，为了加宽点击范围
@property (nonatomic, assign) CGFloat contentWidth;// MSTitleView的宽度
@property (nonatomic, strong) UIColor *buttonNormalColor;
@property (nonatomic, strong) UIColor *buttonSelectedColor;
@property (nonatomic, strong) UIColor *selectionColor;// 默认和 buttonSelectedColor 相同
@property (nonatomic, assign) CGFloat selectionOffsetWidth;// selectionBar 的偏移宽度，比如 button 的宽度是20 selectionOffsetWidth  为10，那么 selectionBar 的宽度就是 20+10
@property (nonatomic, assign, getter=isShowSelectionBar) BOOL showSelectionBar;// 是否显示 showSelectionBar
@property (nonatomic, assign, getter=isShowMoveAnimation) BOOL showMoveAnimation;// 是否显示动画
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id <MSTitleViewDelegate> delegate;

- (instancetype)initWithTitls:(NSArray *)titlsArray clickBlock:(void (^) (UIButton *button))block;
- (void)changTitles:(NSArray<NSString *> *)titles atIndexs:(NSArray<NSNumber *> *)indexs;
- (void)changButtonSelectedColors:(NSArray<UIColor *> *)colors atIndexs:(NSArray<NSNumber *> *)indexs;
- (void)changLastImage:(UIImage *)image;

@end
