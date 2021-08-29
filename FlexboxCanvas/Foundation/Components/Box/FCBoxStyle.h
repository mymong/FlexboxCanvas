//
//  FCBoxStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCComponentParams.h"
#import "FCLayoutStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCBoxStyle : FCComponentParams
@property (nonatomic, readonly) FCLayoutStyle *styleRef;
- (void)setFromString:(NSString *)string;
@end

@interface FCBoxStyle (Helper)
- (void)getDimensions:(CGSize *)dimensions;
- (UIEdgeInsets)border;
- (UIEdgeInsets)contentInsets;
@end

@interface FCBoxStyle (EnumStrs)
- (NSArray<NSString *> *)enumStrsOverflow;
@end

NS_ASSUME_NONNULL_END
