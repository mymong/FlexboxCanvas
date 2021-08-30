//
//  NSString+FCPointValue.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "NSString+FCPointValue.h"
#import "FCSeparators.h"

@implementation NSString (FCPointValue)

- (CGPoint)fc_pointValueWithDefault:(CGPoint)point {
    NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    NSArray *comps = [self componentsSeparatedByString:FCStructComponentSeparator];
    if (comps.count > 1) {
        NSString *str = [comps[0] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            point.x = [str floatValue];
        }
        str = [comps[1] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            point.y = [str floatValue];
        }
    } else {
        NSString *str = [comps[0] stringByTrimmingCharactersInSet:whitespaceCharacterSet];
        if (0 != str.length) {
            point.x = [str floatValue];
            point.y = point.x;
        }
    }
    return point;
}

@end
