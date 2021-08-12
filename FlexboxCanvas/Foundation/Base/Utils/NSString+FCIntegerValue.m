//
//  NSString+FCIntegerValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "NSString+FCIntegerValue.h"

@implementation NSString (FCIntegerValue)

- (NSInteger)fc_integerValueWithDefault:(NSInteger)def {
    if (0 == self.length) {
        return def;
    }
    return [self integerValue];
}

- (NSInteger)fc_integerValueWithDefault:(NSInteger)def minValue:(NSInteger)min {
    NSInteger val = [self fc_integerValueWithDefault:def];
    if (val < min) {
        return min;
    }
    return val;
}

- (NSInteger)fc_integerValueWithDefault:(NSInteger)def minValue:(NSInteger)min maxValue:(NSInteger)max {
    NSInteger val = [self fc_integerValueWithDefault:def minValue:min];
    if (val > max) {
        return max;
    }
    return val;
}

@end
