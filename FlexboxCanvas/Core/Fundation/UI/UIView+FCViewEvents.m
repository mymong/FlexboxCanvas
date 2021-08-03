//
//  UIView+FCViewEvents.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import "UIView+FCViewEvents.h"
#import <objc/runtime.h>

@implementation UIView (FCViewEvents)

- (UIGestureRecognizer *)fc_gestureForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)fc_setGesture:(UIGestureRecognizer *)newGesture forKey:(const void *)key {
    UIGestureRecognizer *oldGesture = [self fc_gestureForKey:key];
    if (oldGesture != newGesture) {
        if (oldGesture) {
            [self removeGestureRecognizer:oldGesture];
        }
        if (newGesture) {
            [self addGestureRecognizer:newGesture];
        }
        objc_setAssociatedObject(self, key, newGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIGestureRecognizer *)fc_gesture_onTouch {
    return [self fc_gestureForKey:@selector(fc_gesture_onTouch)];
}

- (void)setFc_gesture_onTouch:(UIGestureRecognizer *)gesture {
    [self fc_setGesture:gesture forKey:@selector(fc_gesture_onTouch)];
}

- (UIGestureRecognizer *)fc_gesture_onPress {
    return [self fc_gestureForKey:@selector(fc_gesture_onPress)];
}

- (void)setFc_gesture_onPress:(UIGestureRecognizer *)gesture {
    [self fc_setGesture:gesture forKey:@selector(fc_gesture_onPress)];
}

- (UIGestureRecognizer *)fc_gesture_onLongPress {
    return [self fc_gestureForKey:@selector(fc_gesture_onLongPress)];
}

- (void)setFc_gesture_onLongPress:(UIGestureRecognizer *)gesture {
    [self fc_setGesture:gesture forKey:@selector(fc_gesture_onLongPress)];
}

@end
