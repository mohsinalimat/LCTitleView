# LCTitleView

![License MIT](https://img.shields.io/dub/l/vibe-d.svg)
![Pod version](http://img.shields.io/cocoapods/v/LCTitleView.svg?style=flat)
![Platform info](http://img.shields.io/cocoapods/p/LCTitleView.svg?style=flat)

常用的标题视图


##Installation

Cocoapods:
```
pod 'LCTitleView'
```
##Example Usage
```
#import <LCTitleView.h>
```
```
self.titleArray = @[@"午餐", @"小食", @"甜点", @"酱料", @"下午",@"早餐"];
self.titleView.titleArray = _titleArray;
self.titleView.buttonNormalColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f];
self.titleView.buttonSelectedColor = [UIColor colorWithRed:33.0f/255.0f green:175.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
self.titleView.buttonFont = [UIFont systemFontOfSize:13.0f];
//  self.titleView.buttonInsets = 10.0f;
self.titleView.margin = 10.0f;
self.titleView.showSelectionBar = YES;
self.titleView.delegate = self;
self.titleView.targetScrollView = _collectionView;
```





##License
```
The MIT License (MIT)

Copyright (c) 2015 Bawn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
