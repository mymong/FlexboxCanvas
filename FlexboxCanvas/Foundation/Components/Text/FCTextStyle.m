//
//  FCTextStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCTextStyle.h"
#import "NSString+FCFloatValue.h"
#import "NSString+FCIntegerValue.h"
#import "NSString+FCSizeValue.h"
#import "NSArray+FCEnumValue.h"
#import "UIColor+FCColor.h"

#define FCTextDefaultSize 14

static NSArray<NSString *> *FCEnumStrsFontStyle;
static NSArray<NSString *> *FCEnumStrsTextAlign;
static NSArray<NSString *> *FCEnumStrsLineBreak;

void FC_EnumStrs_Setup_TextStyle(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FCEnumStrsFontStyle = @[@"normal", @"italic", @"bold"];
        FCEnumStrsTextAlign = @[@"left", @"center", @"right", @"justify", @"auto"];
        FCEnumStrsLineBreak = @[@"wordWrapping", @"charWrapping", @"clipping", @"truncatingHead", @"truncatingTail", @"truncatingMiddle"];
    });
}

@implementation FCTextStyle

- (instancetype)init {
    if (self = [super init]) {
        FC_EnumStrs_Setup_TextStyle();
    }
    return self;
}

- (void)reset {
    [super reset];
    _fontSize = 0;
    _fontName = nil;
    _fontStyle = FCTextFontStyleNormal;
    _fontWeight = 0;
    _textColor = nil;
    _textAlign = NSTextAlignmentNatural;
    _lineBreak = NSLineBreakByWordWrapping;
    _textShadowColor = nil;
    _textShadowOffset = CGSizeZero;
    _textShadowRadius = 0;
    _numberOfLines = 0;
}

- (void)set_fontSize:(NSString *)str {
    _fontSize = [str fc_floatValueWithDefault:0 minValue:0];
}

- (void)set_fontName:(NSString *)str {
    _fontName = str;
}

- (void)set_fontStyle:(NSString *)str {
    _fontStyle = [FCEnumStrsFontStyle fc_enumValueForStr:str defaultValue:FCTextFontStyleNormal];
}

- (void)set_fontWeight:(NSString *)str {
    _fontWeight = [str fc_integerValueWithDefault:0 minValue:0];
}

- (void)set_textColor:(NSString *)str {
    _textColor = [UIColor fc_colorWithString:str];
}

- (void)set_textAlign:(NSString *)str {
    _textAlign = [FCEnumStrsTextAlign fc_enumValueForStr:str defaultValue:NSTextAlignmentNatural];
}

- (void)set_lineBreak:(NSString *)str {
    _lineBreak = [FCEnumStrsLineBreak fc_enumValueForStr:str defaultValue:NSLineBreakByWordWrapping];
}

- (void)set_textShadowColor:(NSString *)str {
    _textShadowColor = [UIColor fc_colorWithString:str];
}

- (void)set_textShadowOffset:(NSString *)str {
    _textShadowOffset = [str fc_sizeValueWithDefault:CGSizeZero];
}

- (void)set_textShadowRadius:(NSString *)str {
    _textShadowRadius = [str fc_floatValueWithDefault:0 minValue:0];
}

- (void)set_numberOfLines:(NSString *)str {
    _numberOfLines = [str fc_integerValueWithDefault:0 minValue:0];
}

@end

@implementation FCTextStyle (Helper)

- (UIFont *)textFont {
    float size = _fontSize;
    if (size <= 0) {
        size = FCTextDefaultSize;
    }
    
    UIFont *font;
    if (_fontName) {
        font = [UIFont fontWithName:_fontName size:size];
    }
    
    if (!font) {
        if (_fontStyle == FCTextFontStyleItalic) {
            font = [UIFont italicSystemFontOfSize:size];
        } else if (_fontStyle == FCTextFontStyleBold) {
            font = [UIFont boldSystemFontOfSize:size];
        } else if (_fontWeight > 0) {
            if (@available(iOS 8.2, *)) {
                font = [UIFont systemFontOfSize:size weight:_fontWeight];
            } else {
                font = [UIFont systemFontOfSize:size];
            }
        } else {
            font = [UIFont systemFontOfSize:size];
        }
    }
    return font;
}

@end
