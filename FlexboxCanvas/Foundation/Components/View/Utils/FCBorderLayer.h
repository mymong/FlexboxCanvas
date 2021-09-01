//
//  FCBorderLayer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/9/1.
//

#import <UIKit/UIKit.h>
#import "FCBorderThornEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCBorderLayer : CAShapeLayer
@property (nonatomic) UIColor *color;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) CGFloat radius;
@property (nonatomic) UIRectCorner corners;
@property (nonatomic) CGSize thornSize;
@property (nonatomic) FCBorderThornEdge thornEdge;
@property (nonatomic) CGFloat thornLocation;
@property (nonatomic) CGPoint thornAnchor;
@property (nonatomic) BOOL thornSolid;
@end

NS_ASSUME_NONNULL_END
