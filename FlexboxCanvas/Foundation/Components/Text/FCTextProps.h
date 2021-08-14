//
//  FCTextProps.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCViewProps.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCTextProps : FCViewProps
@property (nonatomic, readonly, nullable) NSString *text;
@property (nonatomic, readonly, nullable) NSString *link;
@end

NS_ASSUME_NONNULL_END
