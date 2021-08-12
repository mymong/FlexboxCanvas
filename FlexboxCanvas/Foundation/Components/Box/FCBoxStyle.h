//
//  FCBoxStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCComponentParams.h"
#import "FC_Style.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCBoxStyle : FCComponentParams
@property (nonatomic, readonly) FC_Style *styleRef;
- (void)setFromString:(NSString *)string;
@end

@interface FCBoxStyle (Helper)
- (void)getDimensions:(CGSize *)dimensions;
- (UIEdgeInsets)border;
- (UIEdgeInsets)contentInsets;
@end

NS_ASSUME_NONNULL_END
