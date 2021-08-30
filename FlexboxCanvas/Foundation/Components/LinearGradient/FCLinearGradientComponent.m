//
//  FCBlurEffectComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCLinearGradientComponent.h"
#import "FCLinearGradientProps.h"
#import "FCLinearGradientStyle.h"
#import "FCLinearGradientView.h"

@implementation FCLinearGradientComponent

- (Class)propsClass {
    return [FCLinearGradientProps class];
}

- (Class)managedViewClass {
    return [FCLinearGradientView class];
}

- (void)managedView:(FCLinearGradientView *)view applyProps:(FCLinearGradientProps *)props {
    [super managedView:view applyProps:props];
    
    FCLinearGradientStyle *style = [props style];
    
    view.startPoint = style.startPoint;
    view.endPoint = style.endPoint;
    view.locations = style.locations ?: @[@(0), @(1)];
    view.colors = style.colors ?: @[UIColor.blackColor, UIColor.whiteColor];
}

@end
