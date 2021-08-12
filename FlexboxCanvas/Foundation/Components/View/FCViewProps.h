//
//  FCViewProps.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCBoxProps.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCViewProps : FCBoxProps
@property (nonatomic, readonly, nullable) NSString *nativeView;
@property (nonatomic, readonly) BOOL touchableOpacity;
@property (nonatomic, readonly, nullable) NSString *onRef;
@property (nonatomic, readonly, nullable) NSString *onPress;
@property (nonatomic, readonly, nullable) NSString *onLongPress;
@end

NS_ASSUME_NONNULL_END
