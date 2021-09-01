//
//  UIView+FCBorderLayer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/12.
//

#import "UIView+FCBorderLayer.h"
#import <objc/runtime.h>

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
