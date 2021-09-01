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
#import "FCLayoutNode.h"
#import "UIView+FCViewEvents.h"
#import "UIView+FCBorderLayer.h"
#import "UIGestureRecognizer+FCEventRecognizer.h"
#import "FCTouchGestureRecognizer.h"

@implementation FCViewComponent {
    BOOL _managedViewTouchable;
}

- (Class)propsClass {
    return [FCViewProps class];
}

- (Class)managedViewClass {
    return [UIView class];
}

- (UIView *)createManagedView {
    return [[self managedViewClass] new];
}

- (void)managedView:(UIView *)view applyProps:(FCViewProps *)props {
    NSParameterAssert(view);
    NSParameterAssert(props);
    CGRect rect = view.bounds;
    
    FCViewStyle *style = [props style];
    float borderRadius = [style borderRadius];
    UIRectCorner borderCorners = [style borderCorners];
    
    view.clipsToBounds = style.clipToBounds;
    view.alpha = style.opacity;
    view.backgroundColor = style.backgroundColor;
    
    CALayer *layer = view.layer;
    layer.shadowOffset = style.shadowOffset;
    layer.shadowOpacity = style.shadowOpacity;
    layer.shadowRadius = style.shadowRadius;
    if (style.shadowColor) {
        layer.shadowColor = style.shadowColor.CGColor;
        if (borderRadius > 0 && 0 != borderCorners) {
            layer.shadowPath = [self pathWithRect:rect radius:borderRadius corners:borderCorners].CGPath;
        } else {
            layer.shadowPath = nil;
        }
    } else {
        layer.shadowColor = nil;
        layer.shadowPath = nil;
    }
    
    FCBorderLayer *borderLayer = view.fc_borderLayer;
    BOOL hasCorner = (style.borderRadius > 0 && style.borderCorners != 0);
    BOOL hasBorder = !UIEdgeInsetsEqualToEdgeInsets(style.border, UIEdgeInsetsZero);
    BOOL hasThorn = !CGSizeEqualToSize(style.thornSize, CGSizeZero);
    
    if (hasCorner || hasBorder || hasThorn) {
        if (!borderLayer) {
            view.fc_borderLayer = borderLayer = [FCBorderLayer layer];
        }
        borderLayer.color = style.borderColor;
        borderLayer.insets = style.border;
        borderLayer.radius = style.borderRadius;
        borderLayer.corners = style.borderCorners;
        borderLayer.thornSize = style.thornSize;
        borderLayer.thornEdge = style.thornEdge;
        borderLayer.thornLocation = style.thornLocation;
        borderLayer.thornSolid = style.thornSolid;
        [borderLayer setNeedsLayout];
    } else {
        if (borderLayer) {
            view.fc_borderLayer = nil;
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

- (void)managedViewDecideTouchable:(UIView *)view {
    BOOL isTouchble = _managedViewTouchable;
    if (!isTouchble) {
        for (FCComponent *child in self.children) {
            if ([child isTouchable]) {
                isTouchble = YES;
                break;
            }
        }
    }
    view.userInteractionEnabled = isTouchble;
}

#pragma mark Private

- (UIView *)decideManagedView:(FCViewProps *)props {
    Class clazz = [self managedViewClass];
    
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

#pragma mark FCComponent

- (void)removeFromParent {
    if (_managedView) {
        [self managedViewRemoveEvents:_managedView];
        if (_managedView.superview) {
            [_managedView removeFromSuperview];
        }
        _managedView = nil;
    }
    
    [super removeFromParent];
}

- (void)decideChildFrames {
    for (FCComponent *child in self.children) {
        id<FCLayoutNode> node = child.node;
        if (node) {
            child.frame = [node frame];
        } else {
            child.frame = CGRectZero;
        }
    }
}

- (void)buildManagedView {
    FCViewProps *props = [self props];
    
    UIView *superview = self.parent ? self.parent.view : nil;
    if (!superview) {
        //该组件已被删除
        if (_managedView && _managedView.superview) {
            [_managedView removeFromSuperview];
        }
        return;
    }
    
    CGRect frame = [self frame];
    
    UIView *nextView = [self decideManagedView:props];
    if (!nextView) {
        //创建视图失败
        if (_managedView && _managedView.superview) {
            [_managedView removeFromSuperview];
        }
        return;
    }
    
    nextView.frame = frame;
    
    [self managedView:nextView applyProps:props];
    _managedViewTouchable = [self managedView:nextView buildEvents:props];
    
    //添加到父视图
    if (nextView.superview != superview) {
        [superview addSubview:nextView];
        
        NSString *onRef = props.onRef;
        if (onRef) {
            [self sendEvent:@"onRef" message:onRef userInfo:nil sender:nextView];
        }
    }
    
    //移除旧视图
    if (_managedView != nextView) {
        if (_managedView && _managedView.superview) {
            [_managedView removeFromSuperview];
        }
        _managedView = nextView;
    }
}

- (void)moveManagedView {
    if (_managedView) {
        _managedView.frame = [self frame];
        
        FCBorderLayer *borderLayer = _managedView.fc_borderLayer;
        if (borderLayer) {
            [borderLayer setNeedsLayout];
        }
    }
}

- (void)finishManagedView {
    if (_managedView) {
        [self managedViewDecideTouchable:_managedView];
    }
}

- (BOOL)isTouchable {
    if (_managedView) {
        return _managedView.userInteractionEnabled;
    }
    return NO;
}

#pragma mark <FCComponentParent>

- (UIView *)view {
    return _managedView;
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
    [self sendEvent:gesture.fc_event message:gesture.fc_message userInfo:nil sender:_managedView];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self sendEvent:gesture.fc_event message:gesture.fc_message userInfo:nil sender:_managedView];
    }
}

@end
