//
//  UIView+FCBorderLayer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBorderLayer : CAShapeLayer
@property (nonatomic) UIColor *color;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) CGFloat radius;
@property (nonatomic) UIRectCorner corners;
@end

@interface UIView (FCBorderLayer)
@property (nonatomic, nullable) FCBorderLayer *fc_borderLayer;
@end

NS_ASSUME_NONNULL_END
