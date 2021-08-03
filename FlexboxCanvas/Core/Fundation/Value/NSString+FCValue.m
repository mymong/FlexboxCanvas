//
//  NSString+FCValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/3.
//

#import "NSString+FCValue.h"
#import "FCSeparators.h"
#import "UIColor+FCColor.h"

@implementation NSString (FCValue)

- (CGSize)fc_sizeValue {
    CGSize size = CGSizeZero;
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCStructComponentSeparator];
    size.width = [comps[0] floatValue];
    if (comps.count > 1) {
        size.height = [comps[1] floatValue];
    } else {
        size.height = size.width;
    }
    return size;
}

+ (NSString *)fc_stringFromSizeValue:(CGSize)size {
    return [NSString stringWithFormat:@"%g%@%g", size.width, FCStructComponentSeparator, size.height];
}

- (CGPoint)fc_pointValue {
    CGPoint point = CGPointZero;
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCStructComponentSeparator];
    point.x = [comps[0] floatValue];
    if (comps.count > 1) {
        point.y = [comps[1] floatValue];
    } else {
        point.y = point.x;
    }
    return point;
}

+ (NSString *)fc_stringFromPointValue:(CGPoint)point {
    return [NSString stringWithFormat:@"%g%@%g", point.x, FCStructComponentSeparator, point.y];
}

- (NSArray<NSNumber *> *)fc_floatArrayValue {
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        float value = [comp floatValue];
        [array addObject:@(value)];
    }
    return array;
}

+ (NSString *)fc_stringFromFloatArrayValue:(NSArray<NSNumber *> *)array {
    if (!array || 0 == array.count) {
        return nil;
    }
    NSMutableArray *comps = [NSMutableArray new];
    for (NSNumber *number in array) {
        [comps addObject:[number stringValue]];
    }
    return [comps componentsJoinedByString:FCArrayComponentSeparator];
}

- (NSArray<UIColor *> *)fc_colorArrayValue {
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        UIColor *color = [UIColor fc_colorWithString:comp] ?: [UIColor clearColor];
        [array addObject:color];
    }
    return array;
}

+ (NSString *)fc_stringFromColorArrayValue:(NSArray<UIColor *> *)array {
    if (!array || 0 == array.count) {
        return nil;
    }
    NSMutableArray *comps = [NSMutableArray new];
    for (UIColor *color in array) {
        [comps addObject:[color fc_hexString]];
    }
    return [comps componentsJoinedByString:FCArrayComponentSeparator];
}

@end
