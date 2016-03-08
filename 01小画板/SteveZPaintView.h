//
//  SteveZPaintView.h
//  01小画板
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SteveZPaintView : UIView
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImage *image;

// 清屏
- (void)clearScreen;
// 回退
- (void)undo;
// 橡皮擦
- (void)erase;


@end
