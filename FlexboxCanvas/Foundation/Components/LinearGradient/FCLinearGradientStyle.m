//
//  FCLinearGradientStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCLinearGradientStyle.h"
#import "NSString+FCPointValue.h"
#import "NSString+FCFloatArray.h"
#import "NSString+FCColorArray.h"

@implementation FCLinearGradientStyle

- (NSArray<NSNumber *> *)defaultLocations {
    return @[@(0), @(1)];
}

- (NSArray<UIColor *> *)defaultColors {
    return @[UIColor.blackColor, UIColor.whiteColor];
}

- (void)reset {
    [super reset];
    _startPoint = CGPointZero;
    _endPoint = CGPointMake(1, 1);
    _locations = [self defaultLocations];
    _colors = [self defaultColors];
}

- (void)set_startPoint:(NSString *)str {
    _startPoint = [str fc_pointValueWithDefault:CGPointZero];
}

- (void)set_endPoint:(NSString *)str {
    _endPoint = [str fc_pointValueWithDefault:CGPointMake(1, 1)];
}

- (void)set_locations:(NSString *)str {
    _locations = [str fc_floatArrayWithDefault:0];
}

- (void)set_colors:(NSString *)str {
    _colors = [str fc_colorArrayWithDefault:UIColor.clearColor];
}

@end
