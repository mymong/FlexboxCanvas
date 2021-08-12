//
//  FCTouchGestureRecognizer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import "FCTouchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation FCTouchGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        _originAlpha = 1;
        _opacityRate = 0.7;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count != 1) {
        for (UITouch *touch in touches) {
            [self ignoreTouch:touch forEvent:event];
        }
        return;
    }
    
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint point = [touches.anyObject locationInView:self.view];
    if (!CGRectContainsPoint(self.view.bounds, point)) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateEnded;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    if ([preventedGestureRecognizer isKindOfClass:self.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    if ([preventingGestureRecognizer isKindOfClass:self.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
