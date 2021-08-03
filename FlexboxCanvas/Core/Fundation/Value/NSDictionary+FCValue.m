//
//  NSDictionary+FCValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/3.
//

#import "NSDictionary+FCValue.h"
#import "UIColor+FCColor.h"

@implementation NSDictionary (FCValue)

- (BOOL)fc_boolValueForKey:(NSString *)key compare:(NSString *)yes {
    if (!key) {
        return NO;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return NO;
    }
    if (0 == string.length) {
        return YES;
    }
    if (yes) {
        return [string isEqualToString:yes];
    }
    return [string boolValue];
}

- (float)fc_floatValueForKey:(NSString *)key defaultValue:(float)def {
    return [self fc_floatValueForKey:key defaultValue:def emptyValue:def];
}

- (float)fc_floatValueForKey:(NSString *)key defaultValue:(float)def emptyValue:(float)emp {
    if (!key) {
        return def;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return def;
    }
    if (0 == string.length) {
        return emp;
    }
    return [string floatValue];
}

- (CGSize)fc_sizeValueForKey:(NSString *)key defaultValue:(CGSize)def {
    if (!key) {
        return def;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return def;
    }
    NSArray *comps = [string componentsSeparatedByString:@","];
    if (comps.count >= 2) {
        return CGSizeMake([comps[0] floatValue], [comps[1] floatValue]);
    }
    float value = [string floatValue];
    return CGSizeMake(value, value);
}

- (CGPoint)fc_pointValueForKey:(NSString *)key defaultValue:(CGPoint)def {
    if (!key) {
        return def;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return def;
    }
    NSArray *comps = [string componentsSeparatedByString:@","];
    if (comps.count >= 2) {
        return CGPointMake([comps[0] floatValue], [comps[1] floatValue]);
    }
    float value = [string floatValue];
    return CGPointMake(value, value);
}

- (UIEdgeInsets)fc_edgeValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)def {
    if (!key) {
        return def;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return def;
    }
    NSArray *comps = [string componentsSeparatedByString:@","];
    UIEdgeInsets value;
    value.left = [comps[0] floatValue];
    if (comps.count > 1) {
        value.top = [comps[1] floatValue];
    } else {
        value.top = value.left;
    }
    if (comps.count > 2) {
        value.right = [comps[2] floatValue];
    } else {
        value.right = value.left;
    }
    if (comps.count > 3) {
        value.bottom = [comps[3] floatValue];
    } else {
        value.bottom = value.top;
    }
    return value;
}

- (nullable UIColor *)fc_colorValueForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    NSString *string = [self objectForKey:key];
    if (!string) {
        return nil;
    }
    return [UIColor fc_colorWithString:string];
}

@end
