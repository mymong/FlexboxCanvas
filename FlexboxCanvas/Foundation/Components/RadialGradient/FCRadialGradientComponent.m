//
//  FCRadialGradientComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCRadialGradientComponent.h"
#import "FCRadialGradientProps.h"
#import "FCRadialGradientStyle.h"
#import "FCRadialGradientView.h"

@implementation FCRadialGradientComponent

- (Class)propsClass {
    return [FCRadialGradientProps class];
}

- (Class)managedViewClass {
    return [FCRadialGradientView class];
}

- (void)managedView:(FCRadialGradientView *)view applyProps:(FCRadialGradientProps *)props {
    [super managedView:view applyProps:props];
    
    FCRadialGradientStyle *style = [props style];
    
    view.centerPoint = style.centerPoint;
    view.startRadius = style.startRadius;
    view.endRadius = style.endRadius;
    view.locations = style.locations ?: @[@(0), @(1)];
    view.colors = style.colors ?: @[UIColor.blackColor, UIColor.whiteColor];
}

@end
