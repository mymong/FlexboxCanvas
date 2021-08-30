//
//  FCRadialGradientStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCRadialGradientStyle.h"
#import "NSString+FCPointValue.h"
#import "NSString+FCFloatValue.h"
#import "NSString+FCFloatArray.h"
#import "NSString+FCColorArray.h"

@implementation FCRadialGradientStyle

- (void)reset {
    [super reset];
    _centerPoint = CGPointMake(0.5, 0.5);
    _startRadius = 0.0;
    _endRadius = 1.0;
    _locations = @[@(0), @(1)];
    _colors = @[UIColor.blackColor, UIColor.whiteColor];
}

- (void)set_centerPoint:(NSString *)str {
    _centerPoint = [str fc_pointValueWithDefault:CGPointZero];
}

- (void)set_startRadius:(NSString *)str {
    _startRadius = [str fc_floatValueWithDefault:0.0];
}

- (void)set_endRadius:(NSString *)str {
    _endRadius = [str fc_floatValueWithDefault:1.0];
}

- (void)set_locations:(NSString *)str {
    _locations = [str fc_floatArrayWithDefault:0.0];
}

- (void)set_colors:(NSString *)str {
    _colors = [str fc_colorArrayWithDefault:UIColor.clearColor];
}

@end
