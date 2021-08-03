//
//  FCViewComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/22.
//

#import "FCViewComponent.h"
#import "FCCanvas.h"
#import "FCLayoutNode.h"
#import "NSDictionary+FCValue.h"
#import "UIView+FCViewEvents.h"
#import "UIGestureRecognizer+FCEventRecognizer.h"
#import "FCTouchGestureRecognizer.h"

@implementation FCViewComponent {
    UIView *_view;
    BOOL _touchable;
}

- (Class)viewClass {
    return [UIView class];
}

- (UIView *)createManagedView {
    return [[self viewClass] new];
}

- (void)managedView:(UIView *)view configProps:(NSDictionary *)props {
    NSParameterAssert(view);
    
    NSDictionary *style = props[@"style"] ?: @{};
    NSParameterAssert([style isKindOfClass:NSDictionary.class]);
    
    view.alpha = [style fc_floatValueForKey:@"opacity" defaultValue:1];
    view.backgroundColor = [style fc_colorValueForKey:@"backgroundColor"] ?: [UIColor clearColor];
    view.clipsToBounds = [style fc_boolValueForKey:@"overflow" compare:@"hidden"];
    
    CALayer *layer = view.layer;
    layer.borderColor = [style fc_colorValueForKey:@"borderColor"].CGColor;
    layer.borderWidth = [style fc_floatValueForKey:@"borderWidth" defaultValue:0];
    layer.cornerRadius = [style fc_floatValueForKey:@"borderRadius" defaultValue:0];
    
    layer.shadowColor = [style fc_colorValueForKey:@"shadowColor"].CGColor;
    layer.shadowOffset = [style fc_sizeValueForKey:@"shadowOffset" defaultValue:CGSizeZero];
    layer.shadowOpacity = [style fc_floatValueForKey:@"shadowOpacity" defaultValue:0];
    layer.shadowRadius = [style fc_floatValueForKey:@"shadowRadius" defaultValue:0];
    
    if (layer.shadowColor && layer.cornerRadius > 0) {
        layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:layer.cornerRadius].CGPath;
    } else {
        layer.shadowPath = nil;
    }
}

- (BOOL)managedView:(UIView *)view buildEvents:(NSDictionary *)props {
    BOOL touchable = NO;
    
    NSDictionary *style = props[@"style"];
    NSString *str = style && [style isKindOfClass:NSDictionary.class] ? style[@"touchableOpacity"] : nil;
    if (str) {
        float opacityRate = ({
            float rate = 0.7;
            if (str.length > 0) {
                float floatValue = [str floatValue];
                if (floatValue < 0) {
                    rate = 0;
                } else if (floatValue > 1) {
                    rate = 1;
                } else {
                    rate = floatValue;
                }
            }
            rate;
        });
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
    
    NSString *event = @"onPress";
    NSString *message = props[@"onPress"];
    if (message && message.length > 0) {
        UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)view.fc_gesture_onPress;
        if (!gesture) {
            gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPress:)];
            gesture.fc_event = event;
            gesture.fc_message = message;
            view.fc_gesture_onPress = gesture;
        }
        
        touchable = YES;
    } else {
        view.fc_gesture_onPress = nil;
    }
    
    event = @"onLongPress";
    message = props[@"onLongPress"];
    if (message && message.length > 0) {
        UILongPressGestureRecognizer *gesture = (UILongPressGestureRecognizer *)view.fc_gesture_onLongPress;
        if (!gesture) {
            gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
            gesture.fc_event = event;
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

- (void)buildManagedView:(NSDictionary *)props {
    NSParameterAssert(props);
    
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
    
    [self managedView:nextView configProps:props];
    _touchable = [self managedView:nextView buildEvents:props];
    
    //添加到父视图
    if (nextView.superview != superview) {
        [superview addSubview:nextView];
        
        NSString *onRef = props[@"onRef"];
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

- (UIView *)decideManagedView:(NSDictionary *)props {
    Class clazz = [self viewClass];
    
    UIView *view;
    
    NSString *key = props[@"nativeView"];
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

- (void)frameChildren {
    for (FCComponent *child in self.children) {
        id<FCLayoutNode> node = child.node;
        if (node) {
            child.frame = [node frame];
        } else {
            child.frame = CGRectZero;
        }
    }
}

- (void)startManagedView:(nullable NSDictionary *)props {
    if (props) {
        [self buildManagedView:props];
    } else if (_view) {
        _view.frame = [self frame];
    }
}

- (void)finishManagedView {
    if (_view) {
        [self decideTouchableOfManagedView:_view];
    }
}

#pragma mark <FCComponentParent>

- (UIView *)view {
    return _view;
}

#pragma mark <FCComponentChild>

- (BOOL)isTouchable {
    if (_view) {
        return _view.userInteractionEnabled;
    }
    return NO;
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
