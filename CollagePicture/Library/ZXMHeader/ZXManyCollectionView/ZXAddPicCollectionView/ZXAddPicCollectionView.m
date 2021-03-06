//
//  ZXAddPicCollectionView.m
//  YiShangbao
//
//  Created by simon on 17/3/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXAddPicCollectionView.h"

static NSInteger ZXMaxItemCount = 3;

static CGFloat ZXMinimumInteritemSpacing = 10.f;//item之间最小间隔
static CGFloat ZXMinimumLineSpacing = 10.f; //最小行间距
static CGFloat ZXAddPicItemWidth = 60.f;
static CGFloat ZXAddPicItemHeight = 60.f;

NSInteger const ZXAddPicMaxColoum = 3;  // 图片每行默认最多个数
//设置的时候，xib也要同时调整；
static CGFloat ZXDeleteBtnWidth =  30.f;
static CGFloat ZXDeleteBtnHeight = 30.f;

static NSString * const reuseCell = @"Cell";

@interface ZXAddPicCollectionView ()<ZXAddPicViewCellDelegate>


@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;


@end


@implementation ZXAddPicCollectionView

- (BOOL)isExistInputItem
{
    return _existInputItem;
}
- (void)awakeFromNib
{
    //只用于在加载完ui－initWithCoder之后，对IBOutlet 连接的子控件进行初始化工作；
    [super awakeFromNib];
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //如果写在这里，永远是这个值；
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}
- (void)commonInit
{
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.picItemWidth = ZXAddPicItemWidth;
    self.picItemHeight = ZXAddPicItemHeight;
    self.minimumInteritemSpacing = ZXMinimumInteritemSpacing;
    self.minimumLineSpacing = ZXMinimumLineSpacing;
    self.existInputItem = YES;//添加图片按钮默认存在
    self.maxItemCount = ZXMaxItemCount;
    self.photosState = ZXPhotosViewStateWillCompose;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = self.sectionInset;
    self.collectionFlowLayout = flowLayout;
    
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView = collection;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
    if (!_dataMArray)
    {
        _dataMArray = [NSMutableArray array];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:nib_ZXAddPicViewCell bundle:nil] forCellWithReuseIdentifier:reuseCell];
    self.collectionView.scrollEnabled = NO;
}

// 重写行间距，item宽度，item之间间距；

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    CGFloat itemSpace = minimumInteritemSpacing-ZXDeleteBtnWidth/2;
    itemSpace = itemSpace>0?itemSpace:0;
    _minimumInteritemSpacing = itemSpace;
}

- (void)setPicItemWidth:(CGFloat)picItemWidth
{
    _picItemWidth = picItemWidth +ZXDeleteBtnWidth/2;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    CGFloat space = self.minimumInteritemSpacing-ZXDeleteBtnHeight/2;
    space = space>0?space:0;
    _minimumLineSpacing = space;
}

- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth itemCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset interitemSpacing:(CGFloat)minimumInteritemSpacing
{
    return (totalWidth - (count-1)*minimumInteritemSpacing-inset.left-inset.right)/count-ZXDeleteBtnWidth/2;
}



- (void)setData:(NSArray *)data
{
    [self.dataMArray removeAllObjects];
    
    if ([data count] > self.maxItemCount)
    {
        NSRange range = NSMakeRange(0, self.maxItemCount);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        data = [NSMutableArray arrayWithArray:[data objectsAtIndexes:set]];
    };
    
    [self.dataMArray addObjectsFromArray:data];
    [self.collectionView reloadData];
}




#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isExistInputItem)
    {
        if (_dataMArray.count <self.maxItemCount)
        {
            return self.dataMArray.count+1;
        }
        return self.maxItemCount;
    }
    return self.dataMArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //因为cell右上角放删除按钮，所以左右上下各增加10个距离；
    ZXAddPicViewCell *cell = (ZXAddPicViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    //添加图片按钮
    if (self.isExistInputItem && indexPath.item==self.dataMArray.count&&_dataMArray.count <self.maxItemCount)
    {
        cell.deleteBtn.hidden = YES;
        cell.imageView.image = [UIImage imageNamed:@"zxPhoto_addImage"];
    }
    else
    {
        if (self.photosState ==ZXPhotosViewStateWillCompose)
        {
            id obj = [_dataMArray objectAtIndex:indexPath.item];
            if ([obj isKindOfClass:[UIImage class]])
            {
                cell.imageView.image = (UIImage *)obj;
            }
            if ([obj isKindOfClass:[ZXPhoto class]])
            {
                cell.imageView.image =[(ZXPhoto*)obj image];
            }
        }
        else
        {
            ZXPhoto *photo = (ZXPhoto *)[_dataMArray objectAtIndex:indexPath.item];
            NSURL *url = [NSURL URLWithString:photo.thumbnail_pic];
            [cell.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
        }
      
        cell.deleteBtn.hidden = NO;
    }
    // Configure the cell
    return cell;
}

//删除
- (void)deleteAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.collectionView];
    
    [self addPicCollectionView:self commitEditingStyle:ZXAddPicCellEditingStyleDelete forRowAtIndexPath:indexPath];
}






- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.sectionInset;
    //    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return self.minimumLineSpacing;
    //    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return self.minimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 10);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_picItemWidth, _picItemHeight);

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //“添加图片”按钮事件
    if (indexPath.item ==self.dataMArray.count &&self.isExistInputItem &&_dataMArray.count <self.maxItemCount)
    {
        [self addPicCollectionView:self commitEditingStyle:ZXAddPicCellEditingStyleInsert forRowAtIndexPath:indexPath];
    }
    //其它图片item点击事件
    else
    {
        if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:didSelectPicItemAtIndex:didAddPics:)])
        {
            [self.delegate zx_addPicCollectionView:self didSelectPicItemAtIndex:indexPath.item didAddPics:_dataMArray];
        }
    }
}


#pragma mark - 添加，删除item 编辑事件
- (void)addPicCollectionView:(ZXAddPicCollectionView *)collectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==ZXAddPicCellEditingStyleDelete)
    {
        //当需要动态“添加图片”按钮但而且已经到最大个数，按钮已经隐藏，；
        if (_dataMArray.count == self.maxItemCount && self.isExistInputItem)
        {
            //        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:_dataMArray.count inSection:0];
            //        [collectionView insertItemsAtIndexPaths:@[lastIndexPath]];
            
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            //        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.collectionView reloadData];
        }

        //不需要动态“添加图片”按钮，或有动态“添加图片”按钮且当前显示，点击删除按钮
        else
        {
            [self.dataMArray removeObjectAtIndex:indexPath.item];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        //删除事件
        if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:didDeletedWithTags:forRowAtIndexPath:)])
        {
            NSMutableArray *tagsArray = [_dataMArray mutableCopy];
            [self.delegate zx_addPicCollectionView:self didDeletedWithTags:tagsArray forRowAtIndexPath:indexPath];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(zx_addPicCollectionView:didSelectAddBtnItemAtIndexPath:didAddTags:)])
        {
            
            [self.delegate zx_addPicCollectionView:self didSelectAddBtnItemAtIndexPath:indexPath didAddTags:_dataMArray];
        }
    }
}



- (void)zxDidSingleImageClick:(ZXAddPicViewCell *)photoView
{
    
}

//计算collectionView的总高度

- (CGFloat)getCellHeightWithContentData:(NSArray *)data
{
    
    if (!self.existInputItem && [data count]==0)
    {
        return 0.f;
    }
    else
    {
        [self setData:data];
        //由于整个view被tableViewCell重用了，所以他只会记得init初始化的值；
        [self layoutIfNeeded];
        NSInteger totalItem = [self.collectionView numberOfItemsInSection:0];
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:totalItem-1 inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
        CGFloat height = CGRectGetMaxY(attributes.frame)+self.collectionFlowLayout.sectionInset.bottom+ZXDeleteBtnHeight/2;
        return ceilf(height);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
