//
//  ViewController.m
//  01小画板
//
//  Created by apple on 15-6-11.
//  Copyright (c) 2015年 chang. All rights reserved.
//

#import "ViewController.h"
#import "SteveZPaintView.h"
#import "SteveZPhotoView.h"
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, SteveZPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet SteveZPaintView *paintView;
@property (weak, nonatomic) IBOutlet UISlider *sliderLineWidth;
@property (weak, nonatomic) IBOutlet UIButton *btnRed;


@end

@implementation ViewController


- (void)photoView:(SteveZPhotoView *)photoView withImage:(UIImage *)image
{
    self.paintView.image = image;
    
    // 把这个"透明"的view从父容器中移除
    [photoView removeFromSuperview];
   
}

// 用户选择完毕照片的一个代理方法--------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 我们希望在这里获取用户选择的照片
    //NSLog(@"%@", info);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    // 创建一个图片框, 把用户选择的图片装到图片框里面，然后把图片框添加到paintView中。
    //UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    SteveZPhotoView *photoView = [SteveZPhotoView photoViewWithImage:img frame:self.paintView.frame];
    
    // 设置透明view（SteveZPhotoView的代理）
    photoView.delegate = self;
    
    // 把图片框添加到paintView中
    [self.view addSubview:photoView];
    
    
    // 关闭当前选择照片的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 清屏
- (IBAction)clearScreen:(UIBarButtonItem *)sender {
    [self.paintView clearScreen];
}


// 回退
- (IBAction)undo:(UIBarButtonItem *)sender {
    [self.paintView undo];
}

// 橡皮擦
- (IBAction)erase:(UIBarButtonItem *)sender {
    [self.paintView erase];
}

// 保存
- (IBAction)savePhoto:(UIBarButtonItem *)sender {
    
    //[UIScreen mainScreen].scale
    // 0. 开启一个Bitmap的图形上下文
    UIGraphicsBeginImageContextWithOptions(self.paintView.bounds.size, NO, 0.0);
    
    // 0.1 获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 1. 将paintView中的layer渲染到Bitmap的图形上下文中
    [self.paintView.layer renderInContext:ctx];
    
    
    // 2. 从图形上下文中取出图片
    UIImage *imgPaint = UIGraphicsGetImageFromCurrentImageContext();
    
    // 2.1 关闭上下文
    UIGraphicsEndImageContext();
    
    // 3. 将图片保存到“相册”中
    UIImageWriteToSavedPhotosAlbum(imgPaint, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"操作提示" message:@"保存成功 !" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


// 照片(选择插入一张照片)
- (IBAction)pickPhoto:(UIBarButtonItem *)sender {
    // 1. 创建一个选择照片的控制器
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    
    
    // 1.1 修改打开相册的类型(按照拍照的时间来选择照片)
    imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // 1.2 设置代理
    imgPicker.delegate = self;
    
    
    // 2. 把这个选择照片的控制器modal出来
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    
    // 3.
}





- (IBAction)buttonColorClick:(UIButton *)sender {
    // 1. 获取当前被点击的按钮的背景色
    UIColor *color = sender.backgroundColor;
    
    // 2. 把这个颜色传递"绘图view"
    self.paintView.lineColor = color;
    
}


// 用户滑动了slider了
- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.paintView.lineWidth = sender.value;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 为self.paintView设置一个默认的线宽
    self.paintView.lineWidth = self.sliderLineWidth.value;
    
    // 设置画笔的默认颜色
    self.paintView.lineColor = self.btnRed.backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
