//
//  FCRadialGradientView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCRadialGradientView : UIView
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat startRadius;
@property (nonatomic) CGFloat endRadius;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) NSArray<UIColor *> *colors;
@end

@interface FCRadialGradientLayer : CALayer
@property (nonatomic) CGPoint centerPoint;
@property (nonatomic) CGFloat startRadius;
@property (nonatomic) CGFloat endRadius;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) NSArray *colors; //The array of CGColorRef objects
@end

NS_ASSUME_NONNULL_END
