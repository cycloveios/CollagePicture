//
//  ZXInputBarView.m
//  Baby
//
//  Created by simon on 16/2/23.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "ZXInputBarView.h"

#ifndef UIColorFromRGB
#define UIColorFromRGB(A,B,C)  [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#endif

@interface ZXInputBarView ()

@property (nonatomic, strong) UIView *putView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end


@implementation ZXInputBarView


- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self setupLaysubviews];
        [self registerForKeyboardNotifications];
    }
    return self;
}



- (void)setupLaysubviews
{
    self.putView = [[UIView alloc] init];
    self.putView.backgroundColor = UIColorFromRGB(213.,228.,229.);
    
    self.textView = [[ZXPlaceholdTextView  alloc] init];
    self.textView.placeholder =nil;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.returnKeyType = UIReturnKeySend;
    [self.putView addSubview: self.textView];
    [self addConstraint:self.textView toItem:self.putView];

    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 4;
}


- (void)addConstraint:(UIView *)item toItem:(UIView *)superView
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    //top 间距
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:8];
    [superView addConstraint:constraint1];
    
    //Y的center
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [superView addConstraint:constraint2];
    
    //右间距
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:-6];
    [superView addConstraint:constraint3];
    
    //x的center
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [superView addConstraint:constraint4];
    
}

- (void)showInputBarView
{
    [self showInputBarViewWithIndexPath:nil];
}

- (void)showInputBarViewWithIndexPath:(nullable NSIndexPath *)aIndexPath
{
    UIWindow *view = [[[UIApplication sharedApplication] delegate] window];
    ZXOverlay *overlay = [[ZXOverlay alloc] initWithFrame:view.frame];
    overlay.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    overlay.delegate = self;
    [view addSubview:overlay];
    [overlay addSubview:self.putView];
    self.putView.hidden = YES;
    
    self.putView.frame =CGRectMake(0, CGRectGetMaxY(view.frame)-50, CGRectGetWidth(view.frame), 50);
    if ([self.textView canBecomeFirstResponder])
    {
        [self.textView becomeFirstResponder];
    }
    if (aIndexPath)
    {
        self.indexPath = aIndexPath;
    }
}


- (void)zxOverlaydissmissAction
{
    if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}



#pragma mark-KeyboardNotification
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    self.putView.hidden = NO;
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    __weak __typeof(&*self)weakSelf = self;

    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        
        weakSelf.putView.transform = CGAffineTransformMakeTranslation(0, ty);  //纯代码
        
    }];
}


#pragma mark 键盘即将退出—与上面方法对应；
- (void)keyboardWillHide:(NSNotification *)note{
    
    __weak __typeof(&*self)weakSelf = self;
    self.putView.hidden = YES;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        
        weakSelf.putView.transform = CGAffineTransformIdentity; //纯代码
        weakSelf.putView.superview.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if ([weakSelf.putView.superview isKindOfClass:[ZXOverlay class]])
        {
            [weakSelf.putView.superview removeFromSuperview];
        }
        [weakSelf.putView removeFromSuperview];
        
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
//        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
//        if ([textView.text stringByTrimmingCharactersInSet:whitespace].length==0)
//        {
//            return NO;
//        }
        if ([textView isFirstResponder])
        {
            [textView resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(zxInputBarViewSendContentWithInputView:text:indexPath:)])
            {
                [self.delegate zxInputBarViewSendContentWithInputView:self text:textView.text indexPath:self.indexPath];
                textView.text = nil;
            }
        }
    }
    
    return YES;
}

@end
