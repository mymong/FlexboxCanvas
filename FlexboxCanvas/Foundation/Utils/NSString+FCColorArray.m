//
//  NSString+FCColorArray.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "NSString+FCColorArray.h"
#import "UIColor+FCColor.h"
#import "FCSeparators.h"

@implementation NSString (FCColorArray)

- (NSArray<UIColor *> *)fc_colorArrayWithDefault:(UIColor *)def {
    if (!def) {
        def = [UIColor clearColor];
    }
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        UIColor *color = [UIColor fc_colorWithString:comp];
        if (!color) {
            color = def;
        }
        [array addObject:color];
    }
    return array;
}

@end
