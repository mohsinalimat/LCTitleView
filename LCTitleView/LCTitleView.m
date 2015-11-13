//
//  LCTitleView.m
//  LCTitleViewDemo
//
//  Created by bawn on 9/25/15.
//  Copyright © 2015 https://github.com/bawn. All rights reserved.
//

#import "LCTitleView.h"
#import "Masonry.h"

#define LCSelectionColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]

static CGFloat const LCSelectionHeight = 2.0f;
static CGFloat const LCSelectionWidth = 50.0f;

static void *LCContentOffsetObserverContext = &LCContentOffsetObserverContext;
static void *LCSelectionMoveRateObserverContext = &LCSelectionMoveRateObserverContext;

@interface LCTitleView ()

@property (nonatomic, assign) CGFloat buttonSpace;// 间距
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *selectionBar;
@property (nonatomic, strong) void (^ clickBlock)(UIButton *button);
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation LCTitleView

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
    
    self.selectionWidth = LCSelectionWidth;
    self.backgroundColor = [UIColor clearColor];
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = LCSelectionColor;
    [self addSubview:_bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0.0f);
        make.trailing.equalTo(@0.0f);
        make.bottom.equalTo(@0.0f);
        make.height.equalTo(@0.5f);
    }];
}

- (void)dealloc{
    [self.targetScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"selectionMoveRate"];
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setTitleArray:(NSArray *)titleArray{
    NSAssert(titleArray.count > 1, @"titleArray数量必须>=2");
    if (titleArray.count) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.buttonArray removeAllObjects];
        _titleArray = titleArray;
        [titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
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
                    make.leading.equalTo(lastButton.mas_trailing).offset(_buttonSpace);
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
        [self resetPropertys];
    }
    [self layoutSubviews];
}

- (void)resetPropertys{
    self.margin = _margin;
    self.buttonInsets = _buttonInsets;
    self.buttonFont = _buttonFont;
    self.buttonNormalColor = _buttonNormalColor;
    self.buttonSelectedColor = _buttonSelectedColor;
    self.bottomLineColor = _bottomLineColor;
    self.showBottomLine = _showBottomLine;
    self.selectionColor = _selectionColor;
    self.selectionWidth = _selectionWidth;
    self.showSelectionBar = _showSelectionBar;
    self.currentIndex = _currentIndex;
}


- (void)setMargin:(CGFloat)margin{
    _margin = margin;
    UIButton *firstButton = self.buttonArray.firstObject;
    UIButton *lastButton = self.buttonArray.lastObject;
    [firstButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_margin);
    }];
    [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-_margin);
    }];
}


- (void)setCurrentIndex:(NSUInteger)currentIndex{
    if (currentIndex == _currentIndex) {
        return;
    }
    if (currentIndex > _buttonArray.count - 1) {
        return;
    }
    _currentIndex = currentIndex;
    for (UIButton *button in _buttonArray) {
        button.selected = NO;
    }
    UIButton *currentButton = _buttonArray[_currentIndex];
    currentButton.selected = !currentButton.selected;
    if (self.observationInfo) {
        return;
    }
    if (_showSelectionBar) {
        [self.selectionBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_leading).offset(currentButton.center.x);
        }];
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)setShowSelectionBar:(BOOL)showSelectionBar{
    _showSelectionBar = showSelectionBar;
    if (_showSelectionBar) {
        UIButton *currentButton = self.buttonArray[_currentIndex];
        if (!_selectionBar) {
            self.selectionBar = [[UIView alloc] init];
            self.selectionBar.backgroundColor = _selectionColor ? : _buttonSelectedColor;
            [self addSubview:_selectionBar];
            [self.selectionBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_leading).offset(currentButton.center.x);
                make.height.mas_equalTo(LCSelectionHeight);
                make.bottom.equalTo(@0.0f);
                make.width.mas_equalTo(self.selectionWidth);
            }];
        }
        [self.selectionBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_leading).offset(currentButton.center.x);
        }];
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
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

- (void)setButtonSelectedColor:(UIColor *)buttonSelectedColor{
    _buttonSelectedColor = buttonSelectedColor;
    self.selectionBar.backgroundColor = _buttonSelectedColor;
    
    for (UIButton *button in self.buttonArray) {
        [button setTitleColor:_buttonSelectedColor forState:UIControlStateSelected];
        [button setTitleColor:_buttonSelectedColor forState:UIControlStateHighlighted];
        [button setTitleColor:_buttonSelectedColor forState:UIControlStateHighlighted | UIControlStateSelected];
        
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted | UIControlStateSelected];
    }
}

- (void)setButtonSpace:(CGFloat)buttonSpace{
    _buttonSpace = buttonSpace;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx) {
            UIButton *lastButton = self.buttonArray[idx - 1];
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(lastButton.mas_trailing).offset(_buttonSpace);
            }];
        }
    }];
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


- (void)setSelectionWidth:(CGFloat)selectionWidth{
    _selectionWidth = selectionWidth;
    [self.selectionBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_selectionWidth);
    }];
}

- (void)setTargetScrollView:(UIScrollView *)targetScrollView{
    _targetScrollView = targetScrollView;
    [_targetScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:LCContentOffsetObserverContext];
}

- (void)setSelectionColor:(UIColor *)selectionColor{
    _selectionColor = selectionColor;
    self.selectionBar.backgroundColor = _selectionColor;
}

- (void)setSelectionMoveRate:(NSNumber *)selectionMoveRate{
    _selectionMoveRate = selectionMoveRate;
    if (!self.observationInfo) {
        [self addObserver:self forKeyPath:@"selectionMoveRate" options:NSKeyValueObservingOptionNew context:LCSelectionMoveRateObserverContext];
    }
}

- (void)layoutSubviews{
    UIButton *firstButton = _buttonArray.firstObject;
    if (firstButton.frame.size.width) {
        CGFloat totleWidth = 0.0f;
        for (UIButton *button in _buttonArray) {
            totleWidth += button.frame.size.width;
        }
        self.buttonSpace = (self.frame.size.width - totleWidth - _margin * 2.0f) /  (CGFloat)(_buttonArray.count - 1);
    }
}


#pragma mark - Action

- (void)titleButtonAction:(id)sender{
    if (!_targetScrollView && !self.observationInfo) {
        UIButton *button = (UIButton *)sender;
        NSInteger targetIndex = [self.buttonArray indexOfObject:button];
        if (targetIndex == self.currentIndex) {
            return;
        }
        self.currentIndex = [self.buttonArray indexOfObject:button];
    }
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:didButtonClick:)]) {
        [self.delegate titleView:self didButtonClick:sender];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGFloat newRate = 0.0f;
    if (context == LCContentOffsetObserverContext) {
        NSValue *newOffsetValue = change[NSKeyValueChangeNewKey];
        CGPoint newOffset = [newOffsetValue CGPointValue];
        CGFloat scrollViewWidth = [(UIScrollView *)object bounds].size.width;
        newRate = newOffset.x / scrollViewWidth;
        
        if (newRate >= 0.0f && newRate <= _buttonArray.count - 1) {
            NSInteger currentIndex = (NSInteger)roundf(newRate);
            UIButton *currentButton = self.buttonArray[currentIndex];
            [self.selectionBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_leading).offset((self.frame.size.width + _buttonSpace - _margin * 2) * newRate / _buttonArray.count + currentButton.frame.size.width * 0.5f + _margin);
            }];
            _currentIndex = currentIndex;
            
            for (UIButton *button in _buttonArray) {
                button.selected = NO;
            }
            currentButton.selected = !currentButton.selected;
        }
        
    }
    else{
        newRate = [change[NSKeyValueChangeNewKey] floatValue];
        if (newRate < 0.0f) {
            newRate = 0.0f;
        }
        if (newRate >= 0.0f && newRate <= _buttonArray.count - 1) {
            
            UIButton *firstButton = self.buttonArray.firstObject;
            [self.selectionBar mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_leading).offset((self.frame.size.width + _buttonSpace - _margin * 2) * newRate / _buttonArray.count + firstButton.frame.size.width * 0.5f + _margin);
                
            }];
        }
    }
}

@end
