//
//  FCViewComponent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/22.
//

#import "FCBoxComponent.h"

@class FCViewProps;

NS_ASSUME_NONNULL_BEGIN

@interface FCViewComponent : FCBoxComponent

@property (nonatomic, readonly, nullable) __kindof UIView *managedView;
- (Class)managedViewClass;
- (UIView *)createManagedView;
- (void)managedView:(UIView *)view applyProps:(FCViewProps *)props;
- (BOOL)managedView:(UIView *)view buildEvents:(FCViewProps *)props;
- (void)managedViewRemoveEvents:(UIView *)view;
- (void)managedViewDecideTouchable:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
