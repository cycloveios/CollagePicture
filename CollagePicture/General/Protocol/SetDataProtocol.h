//
//  SetDataProtoct.h
//  Baby
//
//  Created by simon on 16/1/14.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetDataProtoct <NSObject>

- (void)setData:(id)data;


- (void)setTextLab:(id)data1  detailLab:(id)data2;
/**
 根据data数据计算动态计算高度；

 @param data 数据
 @return 高度；
 */
- (CGFloat)getCellHeightWithContentData:(id)data;


/**
 根据indexPath和data 数据（可以是dataArray或model）计算高度

 @param indexPath indexPath
 @param data data数据
 @return 计算的高度
 */
- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data;

@end