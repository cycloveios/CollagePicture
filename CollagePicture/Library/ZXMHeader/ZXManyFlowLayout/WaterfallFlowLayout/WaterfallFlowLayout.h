//
//  WaterfallFlowLayout.h
//  lovebaby
//
//  Created by simon on 16/5/6.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WaterfallFlowLayout;

@protocol WaterfallFlowLayoutDelegate <NSObject>


// 根据item宽度 获取比例高度
- (CGFloat)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  瀑布流获取header的size
 *
 *  @param waterflowLayout waterflowLayout description
 *  @param section         section description
 *
 *  @return return value description
 */
- (CGSize)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout referenceSizeForHeaderInSection:(NSInteger)section;

/** 
 *  是否限制indexPath的高度
 *
 *  @param waterflowLayout waterflowLayout description
 *  @param indexPath       indexPath description
 *
 *  @return return value description
 */
- (BOOL)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout limitItemHeightAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface WaterfallFlowLayout : UICollectionViewFlowLayout


/**
 *  显示多少列
 */
@property (nonatomic,assign) NSInteger columnsCount;
/**
 *  边距
 */
//@property (nonatomic,assign) UIEdgeInsets sectionInset;
/**
 *  每一行之间的间距
 */
@property (nonatomic,assign) CGFloat rowMargin;

/**
 *  每一列之间的间距
 */
@property (nonatomic,assign) CGFloat columnMargin;


@property (nonatomic,weak) id<WaterfallFlowLayoutDelegate>delegate;

@property (nonatomic)BOOL limitItemHeight;
@end


/**
 - (void)addCollectionView
 {
 self.layout.columnMargin = 2;
 self.layout.columnsCount = 2;
 self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
 self.layout.rowMargin = 2;
 self.layout.delegate = self;
 }
 
 - (CGFloat)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
 {
    ThemeListModel *model = [self.dataMArray objectAtIndex:indexPath.item];
    //    NSLog(@"width =%f",width);
    return model.height * width/ model.width ;
 }

 - (CGFloat)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout referenceHeightForItemOfWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
 {
    if (indexPath.item ==0)
    {
        return (79*width)/159;
    }
    YZModel *model = [self.dataMArray objectAtIndex:(indexPath.item-1)];
    //    NSLog(@"width =%f",width);
    return model.h * width/ model.w ;
 }
 - (CGSize)waterflowLayout:(WaterfallFlowLayout *)waterflowLayout referenceSizeForHeaderInSection:(NSInteger)section
 {
 return CGSizeMake(LCDW, 100);
 }

 */
