//
//  UIBezierPath+FCBorderPath.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/31.
//

#import <UIKit/UIKit.h>
#import "FCBorderThornEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (FCBorderPath)
+ (instancetype)fc_bezierPathWithRect:(CGRect)rect radius:(CGSize)radius corners:(UIRectCorner)corners;
+ (instancetype)fc_bezierPathWithRect:(CGRect)rect thorn:(CGSize)thorn edge:(FCBorderThornEdge)edge location:(CGFloat)location;
+ (instancetype)fc_bezierPathWithRect:(CGRect)rect radius:(CGSize)radius corners:(UIRectCorner)corners thorn:(CGSize)thornSize edge:(FCBorderThornEdge)edge location:(CGFloat)location;
+ (instancetype)fc_thornPathWithRect:(CGRect)rect thorn:(CGSize)thornSize edge:(FCBorderThornEdge)edge location:(CGFloat)location;
@end

NS_ASSUME_NONNULL_END
