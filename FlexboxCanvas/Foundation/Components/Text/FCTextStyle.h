//
//  FCTextStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCViewStyle.h"

typedef NS_ENUM(NSInteger, FCTextFontStyle) {
    FCTextFontStyleNormal,
    FCTextFontStyleItalic,
    FCTextFontStyleBold,
};

typedef NS_ENUM(NSInteger, FCTextSizeMode) {
    FCTextSizeModeInherit,
    FCTextSizeModeFitWidth,
    FCTextSizeModeFitHeight,
};

NS_ASSUME_NONNULL_BEGIN

@interface FCTextStyle : FCViewStyle
@property (nonatomic, readonly) float fontSize;
@property (nonatomic, readonly, nullable) NSString *fontName;
@property (nonatomic, readonly) FCTextFontStyle fontStyle;
@property (nonatomic, readonly) float fontWeight;
@property (nonatomic, readonly, nullable) UIColor *textColor;
@property (nonatomic, readonly) NSTextAlignment textAlign;
@property (nonatomic, readonly) NSLineBreakMode lineBreak;
@property (nonatomic, readonly) UIColor *textShadowColor;
@property (nonatomic, readonly) CGSize textShadowOffset;
@property (nonatomic, readonly) float textShadowRadius;
@property (nonatomic, readonly) NSInteger numberOfLines;
@property (nonatomic, readonly) FCTextSizeMode sizeMode;
@end

@interface FCTextStyle (Helper)
- (UIFont *)textFont;
@end

NS_ASSUME_NONNULL_END
