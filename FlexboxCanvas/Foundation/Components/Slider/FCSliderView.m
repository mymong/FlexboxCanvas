//
//  FCSliderView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCSliderView.h"

@implementation FCSliderView

- (void)setThumbView:(UIView *)thumbView {
    UIImage *image = nil;
    if (thumbView) {
        CGFloat alpha = thumbView.alpha;
        thumbView.alpha = 0;

        UIView *view = thumbView;
        CGAffineTransform transform = CGAffineTransformIdentity;

        CGSize size = view.bounds.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextConcatCTM(context, transform);
        [view.layer renderInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        thumbView.alpha = alpha;
    }
    
    [self setThumbImage:image forState:UIControlStateNormal];
    
    if (_thumbView != thumbView) {
        if (_thumbView) {
            [_thumbView removeFromSuperview];
        }
        _thumbView = thumbView;
    }
    
    if (thumbView && thumbView.superview != self) {
        [self addSubview:thumbView];
        thumbView.userInteractionEnabled = NO;
    }
}

- (void)setTipsView:(UIView *)tipsView {
    if (_tipsView != tipsView) {
        if (_tipsView) {
            [_tipsView removeFromSuperview];
        }
        _tipsView = tipsView;
    }
    
    if (tipsView && tipsView.superview != self) {
        [self addSubview:tipsView];
        tipsView.userInteractionEnabled = NO;
    }
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    if (self.thumbView) {
        CGPoint center = CGPointMake(thumbRect.origin.x + thumbRect.size.width / 2, thumbRect.origin.y + thumbRect.size.height / 2);
        self.thumbView.center = center;
        [self bringSubviewToFront:self.thumbView];
    }
    
    if (self.tipsView) {
        CGPoint base = CGPointMake(thumbRect.origin.x + thumbRect.size.width / 2, thumbRect.origin.y - self.tipsSpace);
        CGPoint center = CGPointMake(base.x, base.y - self.tipsView.frame.size.height / 2);
        self.tipsView.center = center;
        [self bringSubviewToFront:self.tipsView];
    }
    
    return thumbRect;
}

@end
