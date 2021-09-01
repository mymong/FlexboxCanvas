//
//  FCBorderLayer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/9/1.
//

#import "FCBorderLayer.h"
#import "UIBezierPath+FCBorderPath.h"

@implementation FCBorderLayer {
    CAShapeLayer *_thornLayer; //镂空边刺的背景色图层
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    if (_thornLayer) {
        [_thornLayer removeFromSuperlayer];
        _thornLayer = nil;
    }
    
    CGRect rect = self.superlayer.bounds;
    
    CGSize radius = CGSizeMake(self.radius, self.radius);
    UIBezierPath *edgePath = [UIBezierPath fc_bezierPathWithRect:rect radius:radius corners:self.corners thorn:self.thornSize edge:self.thornEdge location:self.thornLocation];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = edgePath.CGPath;
    self.superlayer.mask = maskLayer;
    
    UIEdgeInsets insets = self.insets;
    BOOL hasBorder = !UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero);
    BOOL hasThorn = !CGSizeEqualToSize(self.thornSize, CGSizeZero);
    
    if ((self.color && hasBorder) || hasThorn) {
        CGSize thornSize = self.thornSize;
        if (thornSize.width > 0 && thornSize.height > 0) {
            CGFloat b = 0;
            switch (self.thornEdge) {
                case FCBorderThornEdgeLeft:
                    b = insets.left;
                    break;
                case FCBorderThornEdgeTop:
                    b = insets.top;
                    break;
                case FCBorderThornEdgeRight:
                    b = insets.right;
                    break;
                case FCBorderThornEdgeBottom:
                    b = insets.bottom;
                    break;
                default:
                    break;
            }
            CGFloat w = thornSize.width / 2;
            CGFloat h = thornSize.height;
            thornSize.height = h - b * (sqrtf(w * w + h * h) / w - 1);
            thornSize.width *= thornSize.height / h;
        }
        
        //内边区域
        CGRect innerRect = CGRectMake(insets.left, insets.top, rect.size.width - insets.left - insets.right, rect.size.height - insets.top - insets.bottom);
        
        //内边路径
        UIBezierPath *innerPath;
        if (self.thornSolid) {
            innerPath = [UIBezierPath fc_bezierPathWithRect:innerRect radius:radius corners:self.corners];
        } else {
            innerPath = [UIBezierPath fc_bezierPathWithRect:innerRect radius:radius corners:self.corners thorn:thornSize edge:self.thornEdge location:self.thornLocation];
        }
        
        //边框路径
        UIBezierPath *borderPath = [edgePath copy];
        [borderPath appendPath:innerPath.bezierPathByReversingPath];
        self.path = borderPath.CGPath;
        self.fillColor = self.color.CGColor;
        self.zPosition = 100; //置顶
        
        //镂空边刺填充背景色
        if (hasThorn && !self.thornSolid && self.superlayer.backgroundColor) {
            UIBezierPath *thornPath = [UIBezierPath fc_thornPathWithRect:innerRect thorn:thornSize edge:self.thornEdge location:self.thornLocation];
            CAShapeLayer *thornLayer = [CAShapeLayer layer];
            thornLayer.path = thornPath.CGPath;
            thornLayer.fillColor = self.superlayer.backgroundColor;
            [self addSublayer:thornLayer];
            _thornLayer = thornLayer;
        }
    } else {
        self.path = nil;
    }
}

@end
