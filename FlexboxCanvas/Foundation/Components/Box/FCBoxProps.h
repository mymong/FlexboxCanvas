//
//  FCBoxProps.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCBoxStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCBoxProps : FCComponentParams
- (Class)styleClass;
@property (nonatomic, readonly, nullable) __kindof FCBoxStyle *style;
@end

NS_ASSUME_NONNULL_END
