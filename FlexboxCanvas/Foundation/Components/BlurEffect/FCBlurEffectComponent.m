//
//  FCBlurEffectComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/29.
//

#import "FCBlurEffectComponent.h"
#import "FCBlurEffectProps.h"
#import "FCBlurEffectStyle.h"

@implementation FCBlurEffectComponent

#pragma mark FCViewComponent

- (Class)propsClass {
    return [FCBlurEffectProps class];
}

- (Class)managedViewClass {
    return [UIVisualEffectView class];
}

- (void)managedView:(UIVisualEffectView *)view applyProps:(FCBlurEffectProps *)props {
    [super managedView:view applyProps:props];
    
    FCBlurEffectStyle *style = props.style;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style.blurType];
    view.effect = effect;
}

@end
