//
//  SteveZPhotoView.h
//  01小画板
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SteveZPhotoView;
@protocol SteveZPhotoViewDelegate <NSObject>

- (void)photoView:(SteveZPhotoView *)photoView withImage:(UIImage *)image;

@end


@interface SteveZPhotoView : UIView

+ (instancetype)photoViewWithImage:(UIImage *)image frame:(CGRect)frame;

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;


@property (nonatomic, weak) id<SteveZPhotoViewDelegate> delegate;
@end
