//
//  SteveZPaintView.m
//  01小画板
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "SteveZPaintView.h"
#import "SteveZBezierPath.h"
@interface SteveZPaintView ()

// 创建一个用来保存多个SteveZBezierPath对象的数组
@property (nonatomic, strong) NSMutableArray *paths;
@end


@implementation SteveZPaintView


- (void)setImage:(UIImage *)image
{
    _image = image;
    // 创建一个用来绘制图片的UIBezierPath
    SteveZBezierPath *path = [[SteveZBezierPath alloc] init];
    path.image = image;
    [self.paths addObject:path];
    
    // 执行一次重绘
    [self setNeedsDisplay];
}

- (void)clearScreen
{
    [self.paths removeAllObjects];
    // 重绘
    [self setNeedsDisplay];
}

- (void)undo
{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

- (void)erase
{
    self.lineColor = self.backgroundColor;
}


- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取当前触摸对象
    UITouch *touch = touches.anyObject;
    
    // 获取当前触摸的点
    CGPoint loc = [touch locationInView:touch.view];
    
    // 创建一个SteveZBezierPath 对象
    SteveZBezierPath *path = [[SteveZBezierPath alloc] init];
    // 设置线宽
    path.lineWidth = self.lineWidth;
    
    // 设置当前的SteveZBezierPath对象的颜色为self.lineColor
    path.lineColor = self.lineColor;
    
    
    [path moveToPoint:loc];
    
    [self.paths addObject:path];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取当前触摸对象
    UITouch *touch = touches.anyObject;
    
    // 获取当前触摸的点
    CGPoint loc = [touch locationInView:touch.view];
    
    [[self.paths lastObject] addLineToPoint:loc];
    
    // 重绘
    [self setNeedsDisplay];
}

// 实现绘图
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 把数组中的每个path对象都执行一次渲染
    for (SteveZBezierPath *path in self.paths) {
        
        if (path.image != nil) {
            // 因为这个图片，是那个透明view的效果，所以这个图片大小和paintView是一样大的
            [path.image drawAtPoint:CGPointZero];
        } else {
            // 统一设置线头、连接处样式
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineJoinRound;
            
            // 在即将渲染之前, 设置绘图颜色（线条颜色）
            //[self.lineColor set];
            [path.lineColor set];
            
            [path stroke];
        }
    }
}


@end
