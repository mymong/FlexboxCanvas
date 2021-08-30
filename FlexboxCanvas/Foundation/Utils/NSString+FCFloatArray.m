//
//  NSString+FCFloatArray.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "NSString+FCFloatArray.h"
#import "NSString+FCFloatValue.h"
#import "FCSeparators.h"

@implementation NSString (FCFloatArray)

- (NSArray<NSNumber *> *)fc_floatArrayWithDefault:(float)def {
    NSMutableArray *array = [NSMutableArray new];
    NSArray<NSString *> *comps = [self componentsSeparatedByString:FCArrayComponentSeparator];
    for (NSString *comp in comps) {
        float value = [comp fc_floatValueWithDefault:def];
        [array addObject:@(value)];
    }
    return array;
}

@end
