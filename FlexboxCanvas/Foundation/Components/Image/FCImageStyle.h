//
//  FCImageStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/14.
//

#import "FCViewStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCImageStyle : FCViewStyle
@property (nonatomic, readonly) UIColor *tintColor; //为所有非透明的像素指定一个颜色
@property (nonatomic, readonly) UIViewContentMode contentMode;
@end

NS_ASSUME_NONNULL_END
