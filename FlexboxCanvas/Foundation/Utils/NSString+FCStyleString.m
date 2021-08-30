//
//  NSString+FCStyleString.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import "NSString+FCStyleString.h"
#import "FCSeparators.h"


@implementation NSString (FCStyleString)

- (void)fc_enumStylePairsWithBlock:(void(^)(NSString *key, NSString *value))block {
    NSRange range; NSString *key, *value;
    NSArray *pairs = [self componentsSeparatedByString:FCPairSeparator];
    
    for (NSString *pair in pairs) {
        range = [pair rangeOfString:FCKeyValueSeparator];
        if (NSNotFound == range.location) {
            key = [pair stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
            if (key.length > 0) {
                block(key, @"");
            }
        }
        else {
            key = [pair substringToIndex:range.location];
            key = [key stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
            if (key.length > 0) {
                value = [pair substringFromIndex:NSMaxRange(range)];
                value = [value stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
                block(key, value);
            }
        }
    }
}

- (NSDictionary<NSString *, NSString *> *)fc_styleDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [self fc_enumStylePairsWithBlock:^(NSString *key, NSString *value) {
        dictionary[key] = value;
    }];
    return dictionary;
}

@end
