//
//  ZXCenterTitleView.h
//  YiShangbao
//
//  Created by simon on 17/4/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *nibName_ZXCenterTitleView = @"ZXCenterTitleView";


@interface ZXCenterTitleView : UIView

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBtnWidthLayout;
@end


//

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section ==2)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:@"ZXCenterTitleView" owner:self options:nil] lastObject];
        [view.centerBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        [view.centerBtn setImage:[UIImage imageNamed:@"pic_shanghcuanzhaopian"] forState:UIControlStateNormal];
        view.centerBtnWidthLayout.constant = 80.f;
        [view.centerBtn zh_centerHorizontalImageAndTitleWithSpace:10.f];
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;
        
    }
    return [[UIView alloc] init];
}
 
 */
