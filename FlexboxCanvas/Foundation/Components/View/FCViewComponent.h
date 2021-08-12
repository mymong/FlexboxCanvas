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

- (Class)viewClass;
- (UIView *)createManagedView;
- (void)managedView:(UIView *)view applyProps:(FCViewProps *)props;
- (BOOL)managedView:(UIView *)view buildEvents:(FCViewProps *)events;
- (void)managedViewRemoveEvents:(UIView *)view;
- (void)decideTouchableOfManagedView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
