//
//  NSString+FCSizeValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "NSString+FCSizeValue.h"
#import "FCSeparators.h"

@implementation NSString (FCSizeValue)

- (CGSize)fc_sizeValueWithDefault:(CGSize)size {
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSArray *comps = [self componentsSeparatedByString:FCStructComponentSeparator];
    if (comps.count > 1) {
        NSString *str = [comps[0] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            size.width = [str floatValue];
        }
        str = [comps[1] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            size.height = [str floatValue];
        }
    } else {
        NSString *str = [comps[0] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            size.width = [str floatValue];
            size.height = size.width;
        }
    }
    return size;
}

@end
