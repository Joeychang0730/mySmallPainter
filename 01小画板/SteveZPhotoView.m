//
//  SteveZPhotoView.m
//  01小画板
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "SteveZPhotoView.h"

@interface SteveZPhotoView () <UIGestureRecognizerDelegate>

@end

@implementation SteveZPhotoView


- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 根据给定的图片, 创建一个图片框, 并添加到当前的view中
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.center = self.center;
        imgView.userInteractionEnabled = YES; // 允许和用户交互
        imgView.multipleTouchEnabled = YES; // 启用多点触摸
        [self addSubview:imgView];
        
        
        // 为图片框, 添加各种手势操作
        // 1. 拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [imgView addGestureRecognizer:pan];
        
        
        // 2. 旋转手势
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
        rotation.delegate = self;
        [imgView addGestureRecognizer:rotation];
        
        
        // 3. 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        pinch.delegate = self;
        [imgView addGestureRecognizer:pinch];
        
        
        // 4. 长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [imgView addGestureRecognizer:longPress];
    }
    
    return self;
}

// 长按手势
- (void)longPressGesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 让图片闪一下
        [UIView animateWithDuration:0.5 animations:^{
            recognizer.view.alpha = 0.4;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                // 在这里把图片绘制到paint view中
                // 0. 创建（开启）图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                
                // 1. 获取上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                
                // 2. 获取当前的"透明view"中的图形内容
                [self.layer renderInContext:ctx];
                
                // 3. 从上下文中获取图片
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                
                
                // 4. 结束上下文
                UIGraphicsEndImageContext();
                
                
                // 5. 调用代理把当前的图片传递给控制器
                if ([self.delegate respondsToSelector:@selector(photoView:withImage:)]) {
                    [self.delegate photoView:self withImage:img];
                }
            }];
        }];
        
        
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

// 捏合手势
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}

// 旋转手势
- (void)rotationGesture:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}


// 拖拽手势实现
- (void)panGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y);
    
    // 清零
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

+ (instancetype)photoViewWithImage:(UIImage *)image frame:(CGRect)frame
{
    return [[self alloc] initWithImage:image frame:frame];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
