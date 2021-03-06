//
//  ZXADBannerModel.h
//  ICBC
//
//  Created by 朱新明 on 15/3/20.
//  Copyright (c) 2015年 朱新明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZXADBannerModel : NSObject


@property (nonatomic, copy,nullable) NSString *pic;
@property (nonatomic, copy,nullable) NSString *desc;
//跳转地址链接-(可以加自己业务，也可以为h5)
@property (nonatomic, copy,nullable) NSString *url;
@property (nonatomic, strong,nullable) NSNumber *advId;

- (instancetype)initWithDesc:(nullable NSString *)desc picString:(nullable NSString *)picString url:(nullable NSString *)url advId:(nullable NSNumber *)aId;

@end

NS_ASSUME_NONNULL_END



