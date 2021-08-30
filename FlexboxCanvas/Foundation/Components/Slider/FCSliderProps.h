//
//  FCSliderProps.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCViewProps.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCSliderProps : FCViewProps
@property (nonatomic, readonly) NSString *thumbKey;
@property (nonatomic, readonly) NSString *tipsKey;
@property (nonatomic, readonly) NSString *onChange;
@end

NS_ASSUME_NONNULL_END
