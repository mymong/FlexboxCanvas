//
//  UIView+FCViewEvents.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FCViewEvents)
@property (nonatomic, nullable) UIGestureRecognizer *fc_gesture_onTouch;
@property (nonatomic, nullable) UIGestureRecognizer *fc_gesture_onPress;
@property (nonatomic, nullable) UIGestureRecognizer *fc_gesture_onLongPress;
@end

NS_ASSUME_NONNULL_END
