//
//  UIImage+ZXImageHelper.m
//  CollagePicture
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#import "UIImage+ZXImageHelper.h"

@implementation UIImage (ZXImageHelper)






/*
 @brief  用color 和 size 创建 image；
 
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color andSize:(CGSize)size
{
//    UIGraphicsBeginImageContext(CGSize size)
      return [UIImage zh_imageWithColor:color andSize:size opaque:NO];;
}

+ (UIImage *)zh_imageWithColor:(UIColor *)color andSize:(CGSize)size opaque:(BOOL)opaque
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)zh_getGradientImageWithSize:(CGSize)size
                               locations:(const CGFloat[])locations
                              components:(const CGFloat[])components
                                   count:(NSInteger)count
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = (CGPoint){0,0};
    CGPoint endPoint = (CGPoint){size.width,0};
    /*绘制线性渐变
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, colorGradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    
  
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


+ (UIImage *)zh_getGradientImageFromTowColorComponentWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    CGFloat startRed, startGreen, startBlue,startAlpha;
    [startColor getRed:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];
    
    CGFloat endRed, endGreen, endBlue,endAlpha;
    [endColor getRed:&endRed green:&endGreen blue:&endBlue alpha:&endAlpha];
    
    const CGFloat location[] ={0,1};
    const CGFloat components[] ={
        startRed,startGreen,startBlue,startAlpha,
        endRed,endGreen,endBlue,endAlpha
    };
    UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:size locations:location components:components count:2];
    return backgroundImage;
}


+ (UIImage *)zh_scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


+ (UIImage *)zh_scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


+ (UIImage *)zh_getContextImageFromView: (UIView *)view
{
    // draw a view's contents into an image context
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)zh_saveImageWithName:(NSString *)imageName
{
    NSData *imageData;
    if (self.size.width>800)
    {
        imageData = UIImageJPEGRepresentation(self, 0.1);//压缩
    }
    else
    {
        imageData = UIImageJPEGRepresentation(self, 1);
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    NSString *fullPath = [filePath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];

}
@end
