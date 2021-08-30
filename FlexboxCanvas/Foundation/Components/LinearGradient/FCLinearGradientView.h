//
//  FCLinearGradientView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCLinearGradientView : UIView
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) NSArray<UIColor *> *colors;
@end

NS_ASSUME_NONNULL_END
