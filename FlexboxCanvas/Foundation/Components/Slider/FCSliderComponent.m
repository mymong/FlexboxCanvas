//
//  FCSliderComponent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCSliderComponent.h"
#import "FCSliderProps.h"
#import "FCSliderStyle.h"
#import "FCSliderView.h"

@implementation FCSliderComponent

- (Class)propsClass {
    return [FCSliderProps class];
}

- (Class)managedViewClass {
    return [FCSliderView class];
}

- (void)managedView:(FCSliderView *)view applyProps:(FCSliderProps *)props {
    [super managedView:view applyProps:props];
    
    FCSliderStyle *style = [props style];
    
    view.value = style.value;
    view.minimumValue = style.minValue;
    view.maximumValue = style.maxValue;
    
    view.tipsSpace = style.tipsSpace;
}

- (BOOL)managedView:(FCSliderView *)view buildEvents:(FCSliderProps *)props {
    BOOL touchable = [super managedView:view buildEvents:props];
    
    if (props.onChange) {
        [view addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
        [view addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [view addTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [view addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        touchable = YES;
    } else {
        [view removeTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
        [view removeTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [view removeTarget:self action:@selector(onTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [view removeTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    
    return touchable;
}

- (void)finishManagedView {
    [super finishManagedView];
    
    FCSliderView *slider = (FCSliderView *)self.managedView;
    FCSliderProps *props = [self props];
    
    UIView *thumbView = nil;
    NSString *thumbKey = props.thumbKey;
    if (thumbKey) {
        for (FCComponent *child in self.children) {
            if ([child.key isEqualToString:thumbKey] && [child isKindOfClass:FCViewComponent.class]) {
                thumbView = ((FCViewComponent *)child).managedView;
                break;
            }
        }
    }
    slider.thumbView = thumbView;
    
    UIView *tipsView = nil;
    NSString *tipsKey = props.tipsKey;
    if (tipsKey) {
        for (FCComponent *child in self.children) {
            if ([child.key isEqualToString:tipsKey] && [child isKindOfClass:FCViewComponent.class]) {
                tipsView = ((FCViewComponent *)child).managedView;
                tipsView.hidden = YES;
                break;
            }
        }
    }
    slider.tipsView = tipsView;
}

- (void)onValueChanged:(FCSliderView *)slider {
    FCSliderProps *props = [self props];
    
    [self sendEvent:@"onChange" message:props.onChange userInfo:@{
        @"value": @(slider.value),
        @"state": @(0), //moving
    } sender:slider];
}

- (void)onTouchUpInside:(FCSliderView *)slider {
    FCSliderProps *props = [self props];
    
    [self sendEvent:@"onChange" message:props.onChange userInfo:@{
        @"value": @(slider.value),
        @"state": @(1), //confirmed
    } sender:slider];
    
    UIView *tipsView = slider.tipsView;
    if (tipsView) {
        tipsView.hidden = YES;
    }
}

- (void)onTouchUpOutside:(FCSliderView *)slider {
    FCSliderProps *props = [self props];
    
    [self sendEvent:@"onChange" message:props.onChange userInfo:@{
        @"value": @(slider.value),
        @"state": @(2), //cancelled
    } sender:slider];
    
    UIView *tipsView = slider.tipsView;
    if (tipsView) {
        tipsView.hidden = YES;
    }
}

- (void)onTouchDown:(FCSliderView *)slider {
    UIView *tipsView = slider.tipsView;
    if (tipsView) {
        tipsView.hidden = NO;
    }
}

@end
