//
//  FCSliderView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCSliderView : UISlider
@property (nonatomic, nullable) UIView *thumbView;
@property (nonatomic, nullable) UIView *tipsView;
@property (nonatomic) CGFloat tipsSpace;
@end

NS_ASSUME_NONNULL_END
