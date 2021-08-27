//
//  FCScrollViewComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/25.
//

#import "FCScrollViewComponent.h"
#import "FCScrollViewProps.h"

@interface FCScrollViewComponent () <UIScrollViewDelegate>
@end

@implementation FCScrollViewComponent

- (Class)propsClass {
    return [FCScrollViewProps class];
}

- (Class)viewClass {
    return [UIScrollView class];
}

- (void)managedView:(UIScrollView *)view applyProps:(FCScrollViewProps *)props {
    [super managedView:view applyProps:props];
    
    NSParameterAssert([view isKindOfClass:UIScrollView.class]);
    
    if (props.onScroll) {
        view.delegate = self;
    } else {
        view.delegate = nil;
    }
}

- (BOOL)managedView:(UIView *)view buildEvents:(FCViewProps *)events {
    [super managedView:view buildEvents:events];
    return YES; //ScrollView需要交互
}

- (void)finishManagedView {
    [super finishManagedView];
    
    UIScrollView *view = (UIScrollView *)self.view;
    NSParameterAssert([view isKindOfClass:UIScrollView.class]);
    
    if (@available(iOS 11.0, *)) {
        view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    CGSize contentSize = CGSizeZero;
    for (UIView *subview in view.subviews) {
        CGFloat x = CGRectGetMaxX(subview.frame);
        if (contentSize.width < x) {
            contentSize.width = x;
        }
        CGFloat y = CGRectGetMaxY(subview.frame);
        if (contentSize.height < y) {
            contentSize.height = y;
        }
    }
    
    view.contentSize = contentSize;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    FCScrollViewProps *props = [self props];
    
    [self sendEvent:@"onScroll" message:props.onScroll userInfo:@{
        @"contentOffset": [NSValue valueWithCGPoint:scrollView.contentOffset],
    } sender:scrollView];
}

@end
