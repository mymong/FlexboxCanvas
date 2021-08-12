//
//  FCViewComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/22.
//

#import "FCViewComponent.h"
#import "FCViewProps.h"
#import "FCViewStyle.h"
#import "FCCanvas.h"
#import "FC_Node.h"
#import "UIView+FCViewEvents.h"
#import "UIView+FCBorderLayer.h"
#import "UIGestureRecognizer+FCEventRecognizer.h"
#import "FCTouchGestureRecognizer.h"

@implementation FCViewComponent {
    UIView *_view;
    BOOL _touchable;
}

- (Class)propsClass {
    return [FCViewProps class];
}

- (Class)viewClass {
    return [UIView class];
}

- (UIView *)createManagedView {
    return [[self viewClass] new];
}

- (void)managedView:(UIView *)view applyProps:(FCViewProps *)props {
    NSParameterAssert(view);
    NSParameterAssert(props);
    CGRect rect = view.bounds;
    
    FCViewStyle *style = [props style];
    float borderRadius = [style borderRadius];
    UIRectCorner borderCorner = [style borderCorner];
    BOOL isAllCorner = (0 != (borderCorner & UIRectCornerTopLeft) &&
                        0 != (borderCorner & UIRectCornerTopRight) &&
                        0 != (borderCorner & UIRectCornerBottomLeft) &&
                        0 != (borderCorner & UIRectCornerBottomRight));
    
    UIBezierPath *borderOuterPath = nil;
    if (borderRadius > 0) {
        if (isAllCorner) {
            borderOuterPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:borderRadius];
        } else {
            borderOuterPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:borderCorner cornerRadii:CGSizeMake(borderRadius, borderRadius)];
        }
    }
    
    view.clipsToBounds = style.clipToBounds;
    view.alpha = style.opacity;
    view.backgroundColor = style.backgroundColor;
    
    CALayer *layer = view.layer;
    layer.shadowOffset = style.shadowOffset;
    layer.shadowOpacity = style.shadowOpacity;
    layer.shadowRadius = style.shadowRadius;
    if (style.shadowColor) {
        layer.shadowColor = style.shadowColor.CGColor;
        layer.shadowPath = borderOuterPath ? borderOuterPath.CGPath : nil;
    } else {
        layer.shadowColor = nil;
        layer.shadowPath = nil;
    }
    
    UIEdgeInsets border = [style border];
    if (border.left > 0 &&
        border.left == border.top &&
        border.left == border.right &&
        border.left == border.bottom &&
        isAllCorner
        ) {
        layer.borderColor = style.borderColor.CGColor;
        layer.borderWidth = border.left;
        layer.cornerRadius = borderRadius;
        view.fc_borderLayter = nil;
    } else {
        layer.borderColor = nil;
        layer.borderWidth = 0;
        layer.cornerRadius = 0;
        
        if (borderOuterPath) {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = borderOuterPath.CGPath;
            layer.mask = maskLayer;
            layer.masksToBounds = YES;
        } else {
            layer.mask = nil;
            layer.masksToBounds = NO;
        }
        
        if (style.borderColor && (border.left > 0 || border.top > 0 || border.right > 0 || border.bottom > 0)) {
            CAShapeLayer *borderLayter = [CAShapeLayer layer];
            borderLayter.backgroundColor = style.borderColor.CGColor;
            borderLayter.path = borderOuterPath.CGPath;
            borderLayter.zPosition = 100; //置顶
            
            UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:rect];
            rect.origin.x = border.left;
            rect.origin.y = border.top;
            rect.size.width -= border.left + border.right;
            rect.size.height -= border.top + border.bottom;
            UIBezierPath *borderInnerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:borderCorner cornerRadii:CGSizeMake(borderRadius, borderRadius)];
            [borderPath appendPath:borderInnerPath.bezierPathByReversingPath];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = borderPath.CGPath;
            borderLayter.mask = maskLayer;
            
            view.fc_borderLayter = borderLayter;
        } else {
            view.fc_borderLayter = nil;
        }
    }
}

- (BOOL)managedView:(UIView *)view buildEvents:(FCViewProps *)props {
    NSParameterAssert(view);
    NSParameterAssert(props);
    
    BOOL touchable = NO;
    
    if (props.touchableOpacity) {
        float opacityRate = 0.7;
        float originAlpha = view.alpha;
        
        FCTouchGestureRecognizer *gesture = (FCTouchGestureRecognizer *)view.fc_gesture_onTouch;
        if (!gesture) {
            gesture = [[FCTouchGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
            view.fc_gesture_onTouch = gesture;
        } else if (gesture.state == UIGestureRecognizerStateBegan) {
            view.alpha = originAlpha * opacityRate;
        }
        
        gesture.originAlpha = originAlpha;
        gesture.opacityRate = opacityRate;
        
        touchable = YES;
    } else {
        view.fc_gesture_onTouch = nil;
    }
    
    NSString *message = props.onPress;
    if (message && message.length > 0) {
        UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)view.fc_gesture_onPress;
        if (!gesture) {
            gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPress:)];
            gesture.fc_event = @"onPress";
            gesture.fc_message = message;
            view.fc_gesture_onPress = gesture;
        }
        
        touchable = YES;
    } else {
        view.fc_gesture_onPress = nil;
    }
    
    message = props.onLongPress;
    if (message && message.length > 0) {
        UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)view.fc_gesture_onLongPress;
        if (!gesture) {
            gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
            gesture.fc_event = @"onLongPress";
            gesture.fc_message = message;
            view.fc_gesture_onLongPress = gesture;
        }
        
        touchable = YES;
    } else {
        view.fc_gesture_onLongPress = nil;
    }
    
    return touchable;
}

- (void)managedViewRemoveEvents:(UIView *)view {
    view.fc_gesture_onTouch = nil;
    view.fc_gesture_onPress = nil;
    view.fc_gesture_onLongPress = nil;
}

- (void)decideTouchableOfManagedView:(UIView *)view {
    if (!_touchable) {
        for (FCComponent *child in self.children) {
            if ([child isTouchable]) {
                _touchable = YES;
                break;
            }
        }
    }
    view.userInteractionEnabled = _touchable;
}

#pragma mark Private

- (UIView *)decideManagedView:(FCViewProps *)props {
    Class clazz = [self viewClass];
    
    UIView *view;
    
    NSString *key = props.nativeView;
    if (key && key.length > 0) {
        id<FCCanvas> canvas = [self canvas];
        if (canvas) {
            view = [canvas nativeViewForKey:key];
            if (view && [view isKindOfClass:clazz]) {
                return view;
            }
        }
    }
    
    view = [self view];
    if (view && [view isMemberOfClass:clazz]) {
        return view;
    }
    
    return [self createManagedView];
}

#pragma mark FCComponent

- (void)removeFromParent {
    if (_view) {
        [self managedViewRemoveEvents:_view];
        if (_view.superview) {
            [_view removeFromSuperview];
        }
        _view = nil;
    }
    
    [super removeFromParent];
}

- (void)finishNode {
    for (FCComponent *child in self.children) {
        id<FC_Node> node = child.node;
        if (node) {
            child.frame = [node frame];
        } else {
            child.frame = CGRectZero;
        }
    }
}

- (void)startManagedView {
    FCViewProps *props = [self props];
    
    UIView *superview = self.parent ? self.parent.view : nil;
    if (!superview) {
        //该组件已被删除
        if (_view && _view.superview) {
            [_view removeFromSuperview];
        }
        return;
    }
    
    CGRect frame = [self frame];
    
    UIView *nextView = [self decideManagedView:props];
    if (!nextView) {
        //创建视图失败
        if (_view && _view.superview) {
            [_view removeFromSuperview];
        }
        return;
    }
    
    nextView.frame = frame;
    
    [self managedView:nextView applyProps:props];
    _touchable = [self managedView:nextView buildEvents:props];
    
    //添加到父视图
    if (nextView.superview != superview) {
        [superview addSubview:nextView];
        
        NSString *onRef = props.onRef;
        if (onRef) {
            [self sendEvent:@"onRef" message:onRef userInfo:nil sender:nextView];
        }
    }
    
    //移除旧视图
    if (_view != nextView) {
        if (_view && _view.superview) {
            [_view removeFromSuperview];
        }
        _view = nextView;
    }
}

- (void)moveManagedView {
    if (_view) {
        _view.frame = [self frame];
    }
}

- (void)finishManagedView {
    if (_view) {
        [self decideTouchableOfManagedView:_view];
    }
}

- (BOOL)isTouchable {
    if (_view) {
        return _view.userInteractionEnabled;
    }
    return NO;
}

#pragma mark <FCComponentParent>

- (UIView *)view {
    return _view;
}

#pragma mark Events

- (void)onTouch:(FCTouchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.view.alpha = gesture.originAlpha * gesture.opacityRate;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.view.alpha = gesture.originAlpha;
    }
}

- (void)onPress:(UITapGestureRecognizer *)gesture {
    [self sendEvent:gesture.fc_event message:gesture.fc_message userInfo:nil sender:_view];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self sendEvent:gesture.fc_event message:gesture.fc_message userInfo:nil sender:_view];
    }
}

@end
