//
//  FCSliderStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCViewStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCSliderStyle : FCViewStyle
@property (nonatomic, readonly) CGFloat value;
@property (nonatomic, readonly) CGFloat minValue;
@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, readonly) CGFloat tipsSpace;
@end

NS_ASSUME_NONNULL_END
