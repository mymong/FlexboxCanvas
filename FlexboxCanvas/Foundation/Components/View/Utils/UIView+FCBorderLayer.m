//
//  UIView+FCBorderLayer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/12.
//

#import "UIView+FCBorderLayer.h"
#import <objc/runtime.h>

@implementation UIView (FCBorderLayer)

- (CALayer *)fc_borderLayter {
    return objc_getAssociatedObject(self, @selector(fc_borderLayter));
}

- (void)setFc_borderLayter:(CALayer *)newLayer {
    CALayer *oldLayer = [self fc_borderLayter];
    if (oldLayer != newLayer) {
        if (oldLayer) {
            [oldLayer removeFromSuperlayer];
        }
        if (newLayer) {
            [self.layer addSublayer:newLayer];
        }
        objc_setAssociatedObject(self, @selector(fc_borderLayter), newLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
