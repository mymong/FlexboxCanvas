//
//  UIGestureRecognizer+FCEventRecognizer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/1.
//

#import "UIGestureRecognizer+FCEventRecognizer.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (FCEventRecognizer)

- (NSString *)fc_event {
    return objc_getAssociatedObject(self, @selector(fc_event));
}

- (void)setFc_event:(NSString *)event {
    objc_setAssociatedObject(self, @selector(fc_event), event, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)fc_message {
    return objc_getAssociatedObject(self, @selector(fc_message));
}

- (void)setFc_message:(NSString *)message {
    objc_setAssociatedObject(self, @selector(fc_message), message, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
