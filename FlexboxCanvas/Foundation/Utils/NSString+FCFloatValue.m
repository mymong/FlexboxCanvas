//
//  NSString+FCFloatValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "NSString+FCFloatValue.h"

@implementation NSString (FCFloatValue)

- (float)fc_floatValueWithDefault:(float)def {
    if (0 == self.length) {
        return def;
    }
    return [self floatValue];
}

- (float)fc_floatValueWithDefault:(float)def minValue:(float)min {
    float val = [self fc_floatValueWithDefault:def];
    if (val < min) {
        return min;
    }
    return val;
}

- (float)fc_floatValueWithDefault:(float)def minValue:(float)min maxValue:(float)max {
    float val = [self fc_floatValueWithDefault:def minValue:min];
    if (val > max) {
        return max;
    }
    return val;
}

- (float)fc_abs_floatValueWithDefault:(float)def {
    if (0 == self.length) {
        return def;
    }
    return fabsf([self floatValue]);
}

@end
