//
//  MSTitleView.m
//  MishiOS
//
//  Created by bawn on 9/25/15.
//  Copyright © 2015 ___MISHI___. All rights reserved.
//

#import "MSTitleView.h"
#import "Masonry.h"

static CGFloat const MSSelectionBetweenMargin = 20.0f;
static CGFloat const MSSelectionHeight = 2.0f;

@interface MSTitleView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) void (^ clickBlock)(UIButton *button);
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MSTitleView

- (instancetype)initWithTitls:(NSArray *)titlsArray clickBlock:(void (^)(UIButton *))block{
    self = [super init];
    if (self) {
        _titleArray = titlsArray;
        _clickBlock = [block copy];
        [self initUI];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.contentView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
//    self.backgroundColor = [UIColor whiteColor];
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [MSColor smokeGray];
//    [self addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@0.0f);
//        make.trailing.equalTo(@0.0f);
//        make.bottom.equalTo(@0.0f);
//        make.height.equalTo(@0.5f);
//    }];
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setTitleArray:(NSArray *)titleArray{
    if (_titleArray.count) {
        _titleArray = titleArray;
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setTitle:_titleArray[idx] forState:UIControlStateNormal];
            [button layoutIfNeeded];
        }];
    }
    else{
        _titleArray = titleArray;
        [titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.backgroundColor = [UIColor clearColor];
            button.tag = idx;
            [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
            
        }];
        UIButton *firstButton = self.buttonArray.firstObject;
        firstButton.selected = YES;
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (idx) {
                    UIButton *lastButton = self.buttonArray[idx - 1];
                    make.leading.equalTo(lastButton.mas_trailing).offset(self.betweenMargin);
                    if (self.buttonArray.count - 1 == idx) {
                        make.trailing.equalTo(@0.0f);
                    }
                }
                else{
                    make.leading.equalTo(@0.0f);
                }
                make.centerY.equalTo(@0.0f);
                make.height.equalTo(self.contentView);
            }];
        }];
    }
    [self layoutSubviews];
}

- (void)setNormalImages:(NSArray *)normalImages{
    _normalImages = normalImages;
    if (_normalImages) {
        [_normalImages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = self.buttonArray[idx];
            [button setImage:image forState:UIControlStateNormal];
            [button layoutIfNeeded];
        }];
    }
    else{
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setImage:nil forState:UIControlStateNormal];
            [button layoutIfNeeded];
        }];
    }
    [self layoutSubviews];
}

- (void)setSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    if (_selectedImages) {
        [_selectedImages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = self.buttonArray[idx];
            [button setImage:image forState:UIControlStateSelected];
            [button layoutIfNeeded];
        }];
    }
    else{
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setImage:nil forState:UIControlStateSelected];
            [button layoutIfNeeded];
        }];
    }
    [self layoutSubviews];
}


- (void)setCurrentIndex:(NSUInteger)currentIndex{
    if (currentIndex > self.buttonArray.count - 1) {
        return;
    }
    _currentIndex = currentIndex;
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    UIButton *currentButton = self.buttonArray[_currentIndex];
    currentButton.selected = !currentButton.selected;
    if (self.showSelectionBar) {
        [self layoutIfNeeded];
        [self.selectionBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(currentButton);
            make.height.equalTo(@(MSSelectionHeight));// 默认2.0f像素
            make.bottom.equalTo(@0.0f);
            make.width.equalTo(@(currentButton.frame.size.width + MSSelectionBetweenMargin));
        }];
    
        if (self.isShowMoveAnimation) {
            self.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.25f animations:^{
                [self layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.userInteractionEnabled = YES;
            }];
        }
    }
}

- (void)setShowSelectionBar:(BOOL)showSelectionBar{
    _showSelectionBar = showSelectionBar;
    if (_showSelectionBar) {
        if (!self.selectionBar) {
            self.selectionBar = [[UIView alloc] init];
            self.selectionBar.backgroundColor = self.buttonSelectedColor;
            [self.contentView addSubview:self.selectionBar];
            
            [self layoutIfNeeded];
            UIButton *firstButton = self.buttonArray.firstObject;
            [self.selectionBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(firstButton);
                make.height.equalTo(@(MSSelectionHeight));// 默认2.0f像素
                make.bottom.equalTo(@0.0f);
                make.width.equalTo(@(firstButton.frame.size.width + MSSelectionBetweenMargin));
            }];
        }
    }
    else{
        [self.selectionBar removeFromSuperview];
        self.selectionBar = nil;
    }
}

- (void)setButtonNormalColor:(UIColor *)buttonNormalColor{
    _buttonNormalColor = buttonNormalColor;
    for (UIButton *button in self.buttonArray) {
        [button setTitleColor:_buttonNormalColor forState:UIControlStateNormal];
    }
}

- (void)setButtonSelectedColor:(UIColor *)buttonSelectedColor{
    _buttonSelectedColor = buttonSelectedColor;
    self.selectionBar.backgroundColor = _buttonSelectedColor;
    
    for (UIButton *button in self.buttonArray) {
        [button setTitleColor:_buttonSelectedColor forState:UIControlStateHighlighted];
        [button setTitleColor:_buttonSelectedColor forState:UIControlStateSelected];
    }
}

- (void)setBetweenMargin:(CGFloat)betweenMargin{
    _betweenMargin = betweenMargin;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx) {
            UIButton *lastButton = self.buttonArray[idx - 1];
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lastButton.mas_trailing).offset(_betweenMargin);
            }];
        }
    }];
}

- (void)titleButtonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger targetIndex = [self.buttonArray indexOfObject:button];
    if (targetIndex == self.currentIndex) {
        return;
    }
    self.currentIndex = [self.buttonArray indexOfObject:button];
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:didButtonClick:)]) {
        [self.delegate titleView:self didButtonClick:sender];
    }
}

- (void)changTitles:(NSArray<NSString *> *)titles atIndexs:(NSArray<NSNumber *> *)indexs{
    for (NSNumber *index in indexs) {
        UIButton *button = self.buttonArray[index.integerValue];
        [button setTitle:titles[index.integerValue] forState:UIControlStateNormal];
    }
}
- (void)changButtonSelectedColors:(NSArray<UIColor *> *)colors atIndexs:(NSArray<NSNumber *> *)indexs{
    for (NSNumber *index in indexs) {
        UIButton *button = self.buttonArray[index.integerValue];
        [button setTitleColor:colors[index.integerValue] forState:UIControlStateSelected];
        [button setTitleColor:colors[index.integerValue] forState:UIControlStateHighlighted];
    }
}

- (void)setButtonInsets:(CGFloat)buttonInsets{
    _buttonInsets = buttonInsets;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.contentEdgeInsets = UIEdgeInsetsMake(0, _buttonInsets, 0.0f, _buttonInsets);
        [button layoutIfNeeded];
    }];
    [self layoutSubviews];
}

- (void)setButtonFont:(UIFont *)buttonFont{
    _buttonFont = buttonFont;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.titleLabel.font = _buttonFont;
        [button layoutIfNeeded];
    }];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    UIButton *firstButton = self.buttonArray.firstObject;
    if (firstButton.frame.size.width && self.contentWidth) {
        CGFloat totleWidth = 0.0f;
        for (UIButton *button in self.buttonArray) {
            totleWidth += button.frame.size.width;
        }
        self.betweenMargin = (self.contentWidth - totleWidth + self.buttonInsets * 2.0f) /  (CGFloat)(self.buttonArray.count - 1);
    }
}

@end
