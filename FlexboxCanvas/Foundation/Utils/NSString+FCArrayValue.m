//
//  NSString+FCArrayValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "NSString+FCArrayValue.h"
#import "UIColor+FCColor.h"
#import "FCSeparators.h"

@implementation NSString (FCArrayValue)

- (NSArray<NSNumber *> *)floatArrayWithDefault:(NSArray *)def {
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        float value = [comp floatValue];
        [array addObject:@(value)];
    }
    return array;
}

- (NSArray<UIColor *> *)colorArrayWithDefault:(NSArray *)def {
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        UIColor *value = [UIColor fc_colorWithString:comp];
        [array addObject:value ?: [UIColor clearColor]];
    }
    return array;
}

@end
