//
//  FCViewStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCBoxStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCViewStyle : FCBoxStyle
@property (nonatomic, readonly) BOOL clipToBounds;
@property (nonatomic, readonly) float opacity;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *borderColor;
@property (nonatomic, readonly) float borderRadius;
@property (nonatomic, readonly) UIRectCorner borderCorner;
@property (nonatomic, readonly) UIColor *shadowColor;
@property (nonatomic, readonly) CGSize shadowOffset;
@property (nonatomic, readonly) float shadowOpacity;
@property (nonatomic, readonly) float shadowRadius;
@end

NS_ASSUME_NONNULL_END
