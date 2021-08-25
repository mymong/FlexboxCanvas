//
//  UIView+FCBorderLayer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/12.
//

#import "UIView+FCBorderLayer.h"
#import <objc/runtime.h>

@implementation FCBorderLayer

- (void)renderInContext:(CGContextRef)ctx {
    [super renderInContext:ctx];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    CGRect rect = self.superlayer.bounds;
    
    if (self.radius > 0 && 0 != self.corners) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [self pathWithRect:rect radius:self.radius corners:self.corners].CGPath;
        self.superlayer.mask = maskLayer;
    } else {
        self.superlayer.mask = nil;
    }
    
    UIEdgeInsets insets = self.insets;
    if (self.color && (insets.left > 0 || insets.top > 0 || insets.right > 0 || insets.bottom > 0)) {
        self.path = [self pathForBorder:insets withRect:rect radius:self.radius corners:self.corners].CGPath;
        self.fillColor = self.color.CGColor;
        self.zPosition = 100; //置顶
    } else {
        self.path = nil;
    }
}

- (UIBezierPath *)pathWithRect:(CGRect)rect radius:(float)radius corners:(UIRectCorner)corners {
    if (0 == corners) {
        return [UIBezierPath bezierPathWithRect:rect];
    }
    
    if (0 == (corners & UIRectCornerTopLeft) || 0 == (corners & UIRectCornerTopRight) || 0 == (corners & UIRectCornerBottomLeft) || 0 == (corners & UIRectCornerBottomRight)) {
        return [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    }
    
    return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
}

- (UIBezierPath *)pathForBorder:(UIEdgeInsets)border withRect:(CGRect)rect radius:(float)radius corners:(UIRectCorner)corners {
    UIBezierPath *path = [self pathWithRect:rect radius:radius corners:corners];
    rect.origin.x += border.left;
    rect.origin.y += border.top;
    rect.size.width -= border.left + border.right;
    rect.size.height -= border.top + border.bottom;
    UIBezierPath *hollowedPath = [self pathWithRect:rect radius:radius corners:corners];
    [path appendPath:hollowedPath.bezierPathByReversingPath];
    return path;
}

@end

@implementation UIView (FCBorderLayer)

- (FCBorderLayer *)fc_borderLayer {
    return objc_getAssociatedObject(self, @selector(fc_borderLayer));
}

- (void)setFc_borderLayer:(FCBorderLayer *)newLayer {
    CALayer *oldLayer = [self fc_borderLayer];
    if (oldLayer != newLayer) {
        if (oldLayer) {
            [oldLayer removeFromSuperlayer];
        }
        if (newLayer) {
            [self.layer addSublayer:newLayer];
        }
        objc_setAssociatedObject(self, @selector(fc_borderLayer), newLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
