//
//  FCViewStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCViewStyle.h"
#import "UIColor+FCColor.h"
#import "NSString+FCFloatValue.h"
#import "NSString+FCSizeValue.h"
#import "FCSeparators.h"

@implementation FCViewStyle

- (void)reset {
    [super reset];
    _opacity = 1;
    _backgroundColor = [UIColor clearColor];
    _borderColor = nil;
    _borderRadius = 0;
    _borderCorners = UIRectCornerAllCorners;
    _shadowColor = nil;
    _shadowOffset = CGSizeZero;
    _shadowOpacity = 0;
    _shadowRadius = 0;
}

- (BOOL)clipToBounds {
    return (self.styleRef->overflow != FC_Overflow_Visible);
}

- (void)set_opacity:(NSString *)str {
    _opacity = [str fc_floatValueWithDefault:1 minValue:0 maxValue:1];
}

- (void)set_backgroundColor:(NSString *)str {
    _backgroundColor = [UIColor fc_colorWithString:str] ?: [UIColor clearColor];
}

- (void)set_borderColor:(NSString *)str {
    _borderColor = [UIColor fc_colorWithString:str];
}

- (void)set_borderRadius:(NSString *)str {
    _borderRadius = [str fc_floatValueWithDefault:0 minValue:0];
}

- (void)set_borderCorners:(NSString *)str {
    if (0 == str.length) {
        _borderCorners = UIRectCornerAllCorners;
    } else {
        UIRectCorner corner = 0;
        NSArray *comps = [str componentsSeparatedByString:FCArrayComponentSeparator];
        for (NSString *comp in comps) {
            if ([comp isEqualToString:@"all"]) {
                corner = UIRectCornerAllCorners;
            } else if ([comp isEqualToString:@"topLeft"]) {
                corner |= UIRectCornerTopLeft;
            } else if ([comp isEqualToString:@"topRight"]) {
                corner |= UIRectCornerTopRight;
            } else if ([comp isEqualToString:@"bottomLeft"]) {
                corner |= UIRectCornerBottomLeft;
            } else if ([comp isEqualToString:@"bottomRight"]) {
                corner |= UIRectCornerBottomRight;
            } else if ([comp isEqualToString:@"top"]) {
                corner |= UIRectCornerTopLeft;
                corner |= UIRectCornerTopRight;
            } else if ([comp isEqualToString:@"bottom"]) {
                corner |= UIRectCornerBottomLeft;
                corner |= UIRectCornerBottomRight;
            } else if ([comp isEqualToString:@"left"]) {
                corner |= UIRectCornerTopLeft;
                corner |= UIRectCornerBottomLeft;
            } else if ([comp isEqualToString:@"right"]) {
                corner |= UIRectCornerTopRight;
                corner |= UIRectCornerBottomRight;
            }
        }
        _borderCorners = corner;
    }
}

- (void)set_shadowColor:(NSString *)str {
    _shadowColor = [UIColor fc_colorWithString:str];
}

- (void)set_shadowOffset:(NSString *)str {
    _shadowOffset = [str fc_sizeValueWithDefault:CGSizeZero];
}

- (void)set_shadowOpacity:(NSString *)str {
    _shadowOpacity = [str fc_floatValueWithDefault:0 minValue:0 maxValue:1];
}

- (void)set_shadowRadius:(NSString *)str {
    _shadowRadius = [str fc_floatValueWithDefault:0 minValue:0];
}

@end
