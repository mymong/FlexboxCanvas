//
//  NSArray+FCValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/30.
//

#import "NSArray+FCValue.h"

@implementation NSArray (FCValue)

- (NSInteger)fc_enumValueForString:(NSString *)string defaultValue:(NSInteger)def {
    if (!string) {
        return def;
    }
    NSUInteger index = [self indexOfObject:string];
    if (NSNotFound == index) {
        return def;
    }
    return index;
}

- (NSString *)fc_stringForEnumValue:(NSInteger)enumValue defaultString:(NSString *)def {
    if (enumValue < 0 || enumValue >= self.count) {
        return def;
    }
    NSString *string = [self objectAtIndex:enumValue];
    if (![string isKindOfClass:NSString.class]) {
        return def;
    }
    return string;
}

@end
