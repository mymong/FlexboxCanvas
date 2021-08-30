//
//  FCRadialGradientStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCViewStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCRadialGradientStyle : FCViewStyle
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat startRadius;
@property (nonatomic) CGFloat endRadius;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) NSArray<UIColor *> *colors;
@end

NS_ASSUME_NONNULL_END
