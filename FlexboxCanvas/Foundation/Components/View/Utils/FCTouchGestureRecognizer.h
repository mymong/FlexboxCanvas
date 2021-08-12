//
//  FCTouchGestureRecognizer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCTouchGestureRecognizer : UIGestureRecognizer
@property (nonatomic) CGFloat originAlpha;
@property (nonatomic) CGFloat opacityRate;
@end

NS_ASSUME_NONNULL_END
