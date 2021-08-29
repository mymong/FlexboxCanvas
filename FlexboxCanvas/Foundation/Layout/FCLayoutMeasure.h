//
//  FCLayoutMeasure.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/24.
//

#import <UIKit/UIKit.h>

typedef enum FCLayoutMeasureMode {
    FCLayoutMeasureModeUndefined,
    FCLayoutMeasureModeExactly,
    FCLayoutMeasureModeAtMost,
} FCLayoutMeasureMode;

NS_ASSUME_NONNULL_BEGIN

@protocol FCLayoutMeasure <NSObject>
- (CGSize)measureInSize:(CGSize)size widthMode:(FCLayoutMeasureMode)widthMode heightMode:(FCLayoutMeasureMode)heightMode;
@end

NS_ASSUME_NONNULL_END
