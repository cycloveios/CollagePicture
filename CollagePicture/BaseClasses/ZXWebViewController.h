//
//  ZXWebViewController.h
//  ICBC
//
//  Created by 朱新明 on 15/2/10.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



NS_CLASS_AVAILABLE_IOS(7_0)@interface ZXWebViewController : UIViewController


//初始化
- (instancetype)initWithBarTitle:(nullable NSString *)aTitle;


//1.加载网络html页面
-(void)loadWebPageWithUrlString:(NSString *)urlString;

/**
 2.加载本地html网页
 
 @param name 本地HTML文件名
 */
- (void)loadWebHTMLSringWithResource:(NSString *)name;

//3.加载本地文件数据
- (void)loadFileResource:(NSString *)name ofType:(nullable NSString *)ext MIMEType:(NSString *)mimeType;

//加载纯文本数据在webView显示
- (void)loadLocalText:(NSString *)content;



- (void)reloadData;
@end


NS_ASSUME_NONNULL_END
/**
如果ZXWebViewController作为父类，则子类的下面属性
 
NSLog(@"%@",@(self.edgesForExtendedLayout));
NSLog(@"%@",@(self.automaticallyAdjustsScrollViewInsets));

就没有实际效果了；  继承于他的时候，子类要重新设置frame，y轴从64开始；
*/
