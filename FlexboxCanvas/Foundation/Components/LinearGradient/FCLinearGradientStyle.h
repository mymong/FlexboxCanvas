//
//  FCLinearGradientStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCViewStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCLinearGradientStyle : FCViewStyle
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) NSArray<UIColor *> *colors;
@end

NS_ASSUME_NONNULL_END
