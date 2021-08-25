//
//  FC_Measurer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/24.
//

#import <UIKit/UIKit.h>

typedef enum FC_MeasurerMode {
    FC_MeasurerMode_Undefined,
    FC_MeasurerMode_Exactly,
    FC_MeasurerMode_AtMost,
} FC_MeasurerMode;

NS_ASSUME_NONNULL_BEGIN

@protocol FC_Measurer <NSObject>
- (CGSize)measureInSize:(CGSize)size widthMode:(FC_MeasurerMode)widthMode heightMode:(FC_MeasurerMode)heightMode;
@end

NS_ASSUME_NONNULL_END
