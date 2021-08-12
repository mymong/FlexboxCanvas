//
//  NSArray+FCEnumValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "NSArray+FCEnumValue.h"

@implementation NSArray (FCEnumValue)

- (NSInteger)fc_enumValueForStr:(NSString *)str defaultValue:(NSInteger)def {
    NSParameterAssert(str);
    if (!str || 0 == str.length) {
        return def;
    }
    NSUInteger index = [self indexOfObject:str];
    if (NSNotFound == index) {
        return def;
    }
    return index;
}

@end
